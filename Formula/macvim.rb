# Reference: https://github.com/macvim-dev/macvim/wiki/building
class Macvim < Formula
  desc "GUI for vim, made for macOS"
  homepage "https://github.com/macvim-dev/macvim"
  url "https://github.com/macvim-dev/macvim/archive/refs/tags/release-174.tar.gz"
  version "9.0.472"
  sha256 "9481eeca43cfc0a7cf0604088c4b536f274821adb62b0daefada978aa7f4c41b"
  license "Vim"
  revision 2
  head "https://github.com/macvim-dev/macvim.git", branch: "master"

  livecheck do
    url "https://github.com/macvim-dev/macvim/releases?q=prerelease%3Afalse&expanded=true"
    regex(/Updated\s+to\s+Vim\s+v?(\d+(?:\.\d+)+)/i)
    strategy :page_match
  end

  bottle do
    sha256 arm64_ventura:  "6bfdc09ca2b99add2aab85877dc9e44ff37c73e9f8f594f4b619d35df35d8558"
    sha256 arm64_monterey: "b223801cfc94df5f6ca8a11c4d0be1ae240559ab32461d325505a970bbca7fc7"
    sha256 arm64_big_sur:  "3ea26eb1b2b4da3a3caed0ef72fcc155082b1c968d04723ed6c50a9caa8495f0"
    sha256 ventura:        "bd2a166bbded6d54435acb2b27a1f13f33a36cd967f1696df458ef5ad5d66ee9"
    sha256 monterey:       "e7ffda7e075604b7566b18fbd1aad6ed0509212e32f62e1d477d4c82916645cb"
    sha256 big_sur:        "9f1ce443270f7a6dcb74ffc1c71348f2dccd232c70e88b3420dd171a80670b50"
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
