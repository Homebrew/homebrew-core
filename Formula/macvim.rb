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
    sha256 arm64_ventura:  "5f6f4d5b4c3992cfd29768219247c549934b9916a618e69fa91a0e45c820a51e"
    sha256 arm64_monterey: "27e1a597702320e3fd77e5b07c76076b9520d34822d86d7bb85605232ca87a59"
    sha256 arm64_big_sur:  "ef35ccc4db58f560b8dd8f64fb45da71f9519fcc2b3e03e8f510bc7913e53b86"
    sha256 ventura:        "0b7c6adfdcbe8ac0fdd5682c055da621d31424ab4a997208345d882d6f4770c4"
    sha256 monterey:       "6a218196af8bac6a528d7e9dfa8b0f2dd1fa2357da8bd47887cd0af2026eb7b6"
    sha256 big_sur:        "bd6018f7a3e608fc6f143c4e79c3388e05284cc8a689b2ee39a6035ce14eeb0b"
  end

  depends_on xcode: :build
  depends_on "cscope"
  depends_on "gettext"
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
