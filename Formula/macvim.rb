# Reference: https://github.com/macvim-dev/macvim/wiki/building
class Macvim < Formula
  desc "GUI for vim, made for macOS"
  homepage "https://github.com/macvim-dev/macvim"
  url "https://github.com/macvim-dev/macvim/archive/snapshot-166.tar.gz"
  version "8.2-166"
  sha256 "d9745f01c45fb2c1c99ce3b74bf1db6b888805bbb2d2a570bfb5742828ca601a"
  license "Vim"
  revision 1
  head "https://github.com/macvim-dev/macvim.git"

  bottle do
    sha256 "7f672f36e953d8eee8136c9303ac3679da19834e9fea06df2c6735aa3108dd98" => :catalina
    sha256 "1f352a5857f1c071fec1e8acb2a1634d48b2b991b5bc47e50725a3d497aaf4b2" => :mojave
    sha256 "b1cafc8cea7e9f3c3a1692b0c4b33c3f9347626a78bc7171e9013c54494a9994" => :high_sierra
  end

  depends_on xcode: :build
  depends_on "cscope"
  depends_on "gettext"
  depends_on "lua"
  depends_on "python@3.9"
  depends_on "ruby"

  conflicts_with "vim",
    because: "vim and macvim both install vi* binaries"

  # Fix for Big Sur bug, remove in next version
  # https://github.com/macvim-dev/macvim/issues/1113
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/bd6637/macvim/big_sur.patch"
    sha256 "1d3737d664b39f902d22da392869c66397b6b5d8a420d1a83f34f9ffaf963c38"
  end

  def install
    # Avoid issues finding Ruby headers
    ENV.delete("SDKROOT")

    # MacVim doesn't have or require any Python package, so unset PYTHONPATH
    ENV.delete("PYTHONPATH")

    # make sure that CC is set to "clang"
    ENV.clang

    system "./configure", "--with-features=huge",
                          "--enable-multibyte",
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
                          "--enable-python3interp",
                          "--disable-sparkle"
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
    assert_match "+gettext", output

    # Simple test to check if MacVim was linked to Homebrew's Python 3
    py3_exec_prefix = shell_output(Formula["python@3.9"].opt_bin/"python3-config --exec-prefix")
    assert_match py3_exec_prefix.chomp, output
    (testpath/"commands.vim").write <<~EOS
      :python3 import vim; vim.current.buffer[0] = 'hello python3'
      :wq
    EOS
    system bin/"mvim", "-v", "-T", "dumb", "-s", "commands.vim", "test.txt"
    assert_equal "hello python3", (testpath/"test.txt").read.chomp
  end
end
