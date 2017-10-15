# Reference: https://github.com/macvim-dev/macvim/wiki/building
class Macvim < Formula
  desc "GUI for vim, made for macOS"
  homepage "https://github.com/macvim-dev/macvim"
  url "https://github.com/macvim-dev/macvim/archive/snapshot-138.tar.gz"
  version "8.0-138"
  sha256 "3d20968c44fb5831b82c5c4216fb0b4b3da3c90aef8d4ff2f87256d603205ad8"
  head "https://github.com/macvim-dev/macvim.git"

  bottle do
    sha256 "227efc7085abe62d5587a3a44a97d68b0907606e0bbfbb5805c04a980a313caa" => :high_sierra
    sha256 "ced9999958e7e2815da76986b0b890c542eeea85e0309aeb1717e9e276fce1fc" => :sierra
    sha256 "237943e228a6015b791e6e6c9db8e35fab68d9ffc18fdabf037ca1fa1151c43f" => :el_capitan
  end

  option "with-override-system-vim", "Override system vim"
  option "with-true-color", "terminal true color (termguicolors)"

  deprecated_option "override-system-vim" => "with-override-system-vim"

  depends_on :xcode => :build
  depends_on "cscope" => :recommended
  depends_on "lua" => :optional
  depends_on "luajit" => :optional

  if MacOS.version >= :mavericks
    option "with-custom-python", "Build with a custom Python 2 instead of the Homebrew version."
  end

  depends_on :python => :recommended
  depends_on :python3 => :optional

  def install
    # Avoid issues finding Ruby headers
    if MacOS.version == :sierra || MacOS.version == :yosemite
      ENV.delete("SDKROOT")
    end

    # MacVim doesn't have or require any Python package, so unset PYTHONPATH
    ENV.delete("PYTHONPATH")

    # If building for OS X 10.7 or up, make sure that CC is set to "clang"
    ENV.clang if MacOS.version >= :lion

    args = %W[
      --with-features=huge
      --enable-multibyte
      --with-macarchs=#{MacOS.preferred_arch}
      --enable-perlinterp
      --enable-rubyinterp
      --enable-tclinterp
      --enable-terminal
      --with-tlib=ncurses
      --with-compiledby=Homebrew
      --with-local-dir=#{HOMEBREW_PREFIX}
    ]

    args << "--enable-cscope" if build.with? "cscope"

    args << "--enable-terminaltruecolor" if build.with? "true-color"

    if build.with? "lua"
      args << "--enable-luainterp"
      args << "--with-lua-prefix=#{Formula["lua"].opt_prefix}"
    end

    if build.with? "luajit"
      args << "--enable-luainterp"
      args << "--with-lua-prefix=#{Formula["luajit"].opt_prefix}"
      args << "--with-luajit"
    end

    # Allow python or python3, but not both; if the optional
    # python3 is chosen, default to it; otherwise, use python2
    if build.with? "python3"
      args << "--enable-python3interp"
    elsif build.with? "python"
      ENV.prepend "LDFLAGS", `python-config --ldflags`.chomp

      # Needed for <= OS X 10.9.2 with Xcode 5.1
      ENV.prepend "CFLAGS", `python-config --cflags`.chomp.gsub(/-mno-fused-madd /, "")

      framework_script = <<-EOS.undent
        import sysconfig
        print sysconfig.get_config_var("PYTHONFRAMEWORKPREFIX")
      EOS
      framework_prefix = `python -c '#{framework_script}'`.strip
      # Non-framework builds should have PYTHONFRAMEWORKPREFIX defined as ""
      if framework_prefix.include?("/") && framework_prefix != "/System/Library/Frameworks"
        ENV.prepend "LDFLAGS", "-F#{framework_prefix}"
        ENV.prepend "CFLAGS", "-F#{framework_prefix}"
      end
      args << "--enable-pythoninterp"
    end

    system "./configure", *args
    system "make"

    prefix.install "src/MacVim/build/Release/MacVim.app"
    bin.install_symlink prefix/"MacVim.app/Contents/bin/mvim"

    # Create MacVim vimdiff, view, ex equivalents
    executables = %w[mvimdiff mview mvimex gvim gvimdiff gview gvimex]
    executables += %w[vi vim vimdiff view vimex] if build.with? "override-system-vim"
    executables.each { |e| bin.install_symlink "mvim" => e }
  end

  def caveats
    if build.with?("python") && build.with?("python3")
      <<-EOS.undent
        MacVim can no longer be brewed with dynamic support for both Python versions.
        Only Python 3 support has been provided.
      EOS
    end
    if build.with?("true-color")
      <<-EOS.undent
        Terminal True Color isn't supported in Apple Terminal.app
      EOS
    end
  end

  test do
    ENV.prepend_path "PATH", Formula["python"].opt_libexec/"bin"
    # Simple test to check if MacVim was linked to Python version in $PATH
    if build.with? "python"
      system_framework_path = `python-config --exec-prefix`.chomp
      assert_match system_framework_path, `mvim --version`
    end
    assert_match "+ruby", shell_output("#{bin}/mvim --version")
  end
end
