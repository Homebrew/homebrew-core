# Reference: https://github.com/macvim-dev/macvim/wiki/building
class Macvim < Formula
  desc "GUI for vim, made for macOS"
  homepage "https://github.com/macvim-dev/macvim"
  url "https://github.com/macvim-dev/macvim/archive/snapshot-145.tar.gz"
  version "8.0-145"
  sha256 "37ea193345421ea17731fe2a06806641ef6607d38829b195b596179f70810ce2"
  revision 2
  head "https://github.com/macvim-dev/macvim.git"

  bottle do
    sha256 "ce478b3c7f1afc91d737d02bd7db60f60ae1a7ab00f75d35940c0c30278a5056" => :high_sierra
    sha256 "a295c093e5719940c80252fa7a1946e9f9210bfda55358ed9383291886628a0b" => :sierra
    sha256 "940ed97dd30101d88beea849437922dff96a124b8b06daae9a8299b0d6716303" => :el_capitan
  end

  option "with-override-system-vim", "Override system vim"

  deprecated_option "override-system-vim" => "with-override-system-vim"

  depends_on :xcode => :build
  depends_on "cscope" => :recommended
  depends_on "python" => :recommended
  depends_on "lua" => :optional
  depends_on "luajit" => :optional
  depends_on "python@2" => :optional

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

    if build.with? "lua"
      args << "--enable-luainterp"
      args << "--with-lua-prefix=#{Formula["lua"].opt_prefix}"
    end

    if build.with? "luajit"
      args << "--enable-luainterp"
      args << "--with-lua-prefix=#{Formula["luajit"].opt_prefix}"
      args << "--with-luajit"
    end

    # Allow python or python@2, but not both; if the optional
    # python@2 is chosen, default to it; otherwise, use python
    if build.with? "python@2"
      ENV.prepend_path "PATH", Formula["python@2"].opt_libexec/"bin"
      ENV.prepend "LDFLAGS", `python-config --ldflags`.chomp

      # Needed for <= OS X 10.9.2 with Xcode 5.1
      ENV.prepend "CFLAGS", `python-config --cflags`.chomp.gsub(/-mno-fused-madd /, "")

      framework_script = <<~EOS
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
    else
      args << "--enable-python3interp"
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
    if build.with?("python") && build.with?("python@2")
      <<~EOS
        MacVim can no longer be brewed with dynamic support for both Python versions.
        Only Python 2 support has been provided.
      EOS
    end
  end

  test do
    output = shell_output("#{bin}/mvim --version")
    assert_match "+ruby", output

    # Simple test to check if MacVim was linked to Homebrew's Python 3
    if build.with? "python"
      py3_exec_prefix = Utils.popen_read("python3-config", "--exec-prefix")
      assert_match py3_exec_prefix.chomp, output
    end
  end
end
