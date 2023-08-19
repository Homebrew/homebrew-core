# Reference: https://github.com/macvim-dev/macvim/wiki/building
class Macvim < Formula
  desc "GUI for vim, made for macOS"
  homepage "https://github.com/macvim-dev/macvim"
  url "https://github.com/macvim-dev/macvim/archive/refs/tags/release-177.tar.gz"
  version "9.0.1677"
  sha256 "f0c7ce7bc81b1cecb9e9c3c39c35b9a02a3ea1f08f9131a6032f9c8bff6aa8d7"
  license "Vim"
  head "https://github.com/macvim-dev/macvim.git", branch: "master"

  livecheck do
    url "https://github.com/macvim-dev/macvim/releases?q=prerelease%3Afalse&expanded=true"
    regex(/Updated\s+to\s+Vim\s+v?(\d+(?:\.\d+)+)/i)
    strategy :page_match
  end

  bottle do
    sha256 cellar: :any, arm64_ventura:  "21f73599154f9ef9735e61a97d62615b0a45e206af858226c771314c4d7c2a9a"
    sha256 cellar: :any, arm64_monterey: "4fae5d2ba975d10f3151b011cedfe629c536ce8193b8d5e4ebe47454483293f1"
    sha256 cellar: :any, arm64_big_sur:  "82f035e74844bf119294c853d9887dec92d5a878758e81d889f6217a89b73bfe"
    sha256 cellar: :any, ventura:        "ad71a9cd875e50ea1f41bc0fad8448a1a63feea77ea22bc64adb27f07097f81d"
    sha256 cellar: :any, monterey:       "911ca9a54aa9f50db6f186bf18133626c90e98f2e644241d4b4995af25bc1440"
    sha256 cellar: :any, big_sur:        "816541af345e5ed66dfc641b36a0e4f4de2a324645fb80389f62dc9ac5a1692c"
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
