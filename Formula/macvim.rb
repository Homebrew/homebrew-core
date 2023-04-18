# Reference: https://github.com/macvim-dev/macvim/wiki/building
class Macvim < Formula
  desc "GUI for vim, made for macOS"
  homepage "https://github.com/macvim-dev/macvim"
  url "https://github.com/macvim-dev/macvim/archive/refs/tags/release-176.tar.gz"
  version "9.0.1276"
  sha256 "e729964b4979f42fd2701236adb9bea35c6cf3981aa02ae7790a240fb92cf39e"
  license "Vim"
  head "https://github.com/macvim-dev/macvim.git", branch: "master"

  livecheck do
    url "https://github.com/macvim-dev/macvim/releases?q=prerelease%3Afalse&expanded=true"
    regex(/Updated\s+to\s+Vim\s+v?(\d+(?:\.\d+)+)/i)
    strategy :page_match
  end

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_ventura:  "6bb6a8a82b9bb7ace5eb9f34f1571d7b36d4bf553f50941ce147ca41cd8f85d8"
    sha256 cellar: :any, arm64_monterey: "e889d6c32cffdcc33f2bfe6ca04146c5d96ba9553cb2b50db8837007960494c1"
    sha256 cellar: :any, arm64_big_sur:  "b2849fff6142ba20264b21ac9fad8f55487cbae05b64fe750d14f223f454594a"
    sha256 cellar: :any, ventura:        "82f5456d5dce39f23dcd1cf317e9f652eb19bdd0989f9aaee088df7d49364aca"
    sha256 cellar: :any, monterey:       "3ffeaf80f4fa63c0589526538fae88986550113e356f820868c65416ed9d060e"
    sha256 cellar: :any, big_sur:        "1fedbf1fb207c159c977f331b6be5aad689fd7551287840a066fe94bda73efea"
  end

  depends_on "gettext" => :build
  depends_on "libsodium" => :build
  depends_on xcode: :build
  depends_on "cscope"
  depends_on "lua"
  depends_on :macos
  depends_on "python@3.11"
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
    assert_match "+sodium", output

    # Simple test to check if MacVim was linked to Homebrew's Python 3
    py3_exec_prefix = shell_output(Formula["python@3.11"].opt_libexec/"bin/python-config --exec-prefix")
    assert_match py3_exec_prefix.chomp, output
    (testpath/"commands.vim").write <<~EOS
      :python3 import vim; vim.current.buffer[0] = 'hello python3'
      :wq
    EOS
    system bin/"mvim", "-v", "-T", "dumb", "-s", "commands.vim", "test.txt"
    assert_equal "hello python3", (testpath/"test.txt").read.chomp
  end
end
