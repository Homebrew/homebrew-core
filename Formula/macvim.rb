# Reference: https://github.com/macvim-dev/macvim/wiki/building
class Macvim < Formula
  desc "GUI for vim, made for macOS"
  homepage "https://github.com/macvim-dev/macvim"
  url "https://github.com/macvim-dev/macvim/archive/refs/tags/release-174.tar.gz"
  version "9.0.472"
  sha256 "9481eeca43cfc0a7cf0604088c4b536f274821adb62b0daefada978aa7f4c41b"
  license "Vim"
  revision 1
  head "https://github.com/macvim-dev/macvim.git", branch: "master"

  bottle do
    sha256 arm64_monterey: "a22ed2ccf2de13d727bb47798cdbec5595634e24e7b9ab70d1d1ef7836fe41b8"
    sha256 arm64_big_sur:  "3f990eede6cb56c75bbe5f30aa8c00179a14479eaf4f4628a51ca430b8ede725"
    sha256 monterey:       "cc2ac74c81bf5dcf1e759bf2965b8c1c66a4aa31fc8662a179c9eae7dcaf31ed"
    sha256 big_sur:        "7529db993173ac24d9239857fa8fd95f58b7a054b3b9243fc21ae58d358597b8"
    sha256 catalina:       "6403a4d6c0330ecaa97c50d6c373c896f00b9f41ae02b7f1ac9ce685329c058f"
  end

  depends_on xcode: :build
  depends_on "cscope"
  depends_on "gettext"
  depends_on "lua"
  depends_on :macos
  depends_on "python@3.10"
  depends_on "ruby"

  conflicts_with "vim", because: "vim and macvim both install vi* binaries"

  def install
    # Avoid issues finding Ruby headers
    ENV.delete("SDKROOT")

    # MacVim doesn't have or require any Python package, so unset PYTHONPATH
    ENV.delete("PYTHONPATH")

    # We don't want the deployment target to include the minor version on Big Sur and newer.
    # https://github.com/Homebrew/homebrew-core/issues/111693
    ENV["MACOSX_DEPLOYMENT_TARGET"] = MacOS.version

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
                          "--disable-sparkle",
                          "--with-macarchs=#{Hardware::CPU.arch}"
    system "make"

    prefix.install "src/MacVim/build/Release/MacVim.app"
    # Remove autoupdating universal binaries
    (prefix/"MacVim.app/Contents/Frameworks/Sparkle.framework").rmtree
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
    py3_exec_prefix = shell_output(Formula["python@3.10"].opt_libexec/"bin/python-config --exec-prefix")
    assert_match py3_exec_prefix.chomp, output
    (testpath/"commands.vim").write <<~EOS
      :python3 import vim; vim.current.buffer[0] = 'hello python3'
      :wq
    EOS
    system bin/"mvim", "-v", "-T", "dumb", "-s", "commands.vim", "test.txt"
    assert_equal "hello python3", (testpath/"test.txt").read.chomp
  end
end
