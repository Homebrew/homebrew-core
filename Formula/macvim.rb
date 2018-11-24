# Reference: https://github.com/macvim-dev/macvim/wiki/building
class Macvim < Formula
  desc "GUI for vim, made for macOS"
  homepage "https://github.com/macvim-dev/macvim"
  url "https://github.com/macvim-dev/macvim/archive/snapshot-151.tar.gz"
  version "8.1-151"
  sha256 "4752e150ac509f19540c0f292eda9bf435b8986138514ad2e1970cc82a2ba4fc"
  revision 1
  head "https://github.com/macvim-dev/macvim.git"

  bottle do
    sha256 "7986e391f3534812c84d321cd4884377c062249c405300c4747a47bd5489539a" => :mojave
    sha256 "2a93ea907a16f68918376b1d9e4c75293823f7b2a8a0e4d5d49fa608a9e20120" => :high_sierra
    sha256 "cb015ff88dc664a765fe8b212e0edc186de6efdff5b290d708f531a34bbd8749" => :sierra
    sha256 "029365cfcc11097d216e12e431cc779c805bff5592a35bc337144e72c093e02f" => :el_capitan
  end

  depends_on :xcode => :build
  depends_on "cscope"
  depends_on "lua"
  depends_on "luajit"
  depends_on "python"

  def install
    # Avoid issues finding Ruby headers
    if MacOS.version == :sierra || MacOS.version == :yosemite
      ENV.delete("SDKROOT")
    end

    # MacVim doesn't have or require any Python package, so unset PYTHONPATH
    ENV.delete("PYTHONPATH")

    # If building for OS X 10.7 or up, make sure that CC is set to "clang"
    ENV.clang if MacOS.version >= :lion

    system "./configure", "--with-features=huge",
                          "--enable-multibyte",
                          "--with-macarchs=#{MacOS.preferred_arch}",
                          "--enable-perlinterp",
                          "--enable-rubyinterp",
                          "--enable-tclinterp",
                          "--enable-terminal",
                          "--with-tlib=ncurses",
                          "--with-compiledby=Homebrew",
                          "--with-local-dir=#{HOMEBREW_PREFIX}",
                          "--enable-cscope",
                          "--enable-luainterp",
                          "--with-lua-prefix=#{Formula["lua"].opt_prefix}",
                          "--enable-luainterp",
                          "--with-lua-prefix=#{Formula["luajit"].opt_prefix}",
                          "--with-luajit",
                          "--enable-python3interp"
    system "make"

    prefix.install "src/MacVim/build/Release/MacVim.app"
    bin.install_symlink prefix/"MacVim.app/Contents/bin/mvim"

    # Create MacVim vimdiff, view, ex equivalents
    executables = %w[mvimdiff mview mvimex gvim gvimdiff gview gvimex]
    executables += %w[vi vim vimdiff view vimex]
    executables.each { |e| bin.install_symlink "mvim" => e }
  end

  test do
    output = shell_output("#{bin}/mvim --version")
    assert_match "+ruby", output

    # Simple test to check if MacVim was linked to Homebrew's Python 3
    py3_exec_prefix = Utils.popen_read("python3-config", "--exec-prefix")
    assert_match py3_exec_prefix.chomp, output
    (testpath/"commands.vim").write <<~EOS
      :python3 import vim; vim.current.buffer[0] = 'hello python3'
      :wq
    EOS
    system bin/"mvim", "-v", "-T", "dumb", "-s", "commands.vim", "test.txt"
    assert_equal "hello python3", (testpath/"test.txt").read.chomp
  end
end
