# Reference: https://github.com/macvim-dev/macvim/wiki/building
class Macvim < Formula
  desc "GUI for vim, made for macOS"
  homepage "https://github.com/macvim-dev/macvim"
  license "Vim"
  head "https://github.com/macvim-dev/macvim.git", branch: "master"

  stable do
    url "https://github.com/macvim-dev/macvim/archive/refs/tags/release-178.tar.gz"
    version "9.0.1897"
    sha256 "ec614f8609aa61948e01c8ea57f133e29c9a3f67375dde65747ba537d8a713e6"

    # Backport Python 3.12 fix. Remove in the next release.
    patch do
      url "https://github.com/vim/vim/commit/fa145f200966e47e11c403520374d6d37cfd1de7.patch?full_index=1"
      sha256 "b449dbcb51e6725b5365a12f987ebe1265bdaf1665bbe3bce4566478957d796d"
    end

    # Backport Sonoma tabs fix. Remove in the next release.
    patch do
      url "https://github.com/macvim-dev/macvim/commit/e9167c29dbf3dd5bb80b48c6425c7b20301a8d44.patch?full_index=1"
      sha256 "cdeff4ea17bd3f67022f17b78d6ccf9bc8a90b4b1a18b721bd3f65103bfef04e"
    end
  end

  # The stable Git tags use a `release-123` format and it's necessary to check
  # the GitHub release description to identify the Vim version from the
  # "Updated to Vim 1.2.3456" text.
  livecheck do
    url :stable
    regex(/Updated\s+to\s+Vim\s+v?(\d+(?:\.\d+)+)/i)
    strategy :github_latest do |json, regex|
      match = json["body"]&.match(regex)
      next if match.blank?

      match[1]
    end
  end

  bottle do
    rebuild 2
    sha256 cellar: :any, arm64_sonoma:   "fda1a97a800cb89b911022b87b90b3fe6380f69f8b2b1b12d0baa9a2abe9a814"
    sha256 cellar: :any, arm64_ventura:  "0f6d8a14b823222f1b03a433bb909c661089ca395731102e6ce3ae9018b57a72"
    sha256 cellar: :any, arm64_monterey: "a6ef419c1ce029e7b6ab1de1d32ebcd4051631770ab828a059539955edd21ddc"
    sha256 cellar: :any, sonoma:         "b4e67cdcf670acb517aadfeefd58ead3c7d0d0e35593d19439320eed7ca217eb"
    sha256 cellar: :any, ventura:        "e1d5098b6cf716b96232ef23846da9d0685e5600a19a664dcff63c0cca90b6b2"
    sha256 cellar: :any, monterey:       "b2b5d66fb9821b41d978faba09af9f663c19182c074a627dfd6165117cd8c96a"
  end

  depends_on "gettext" => :build
  depends_on "libsodium" => :build
  depends_on xcode: :build
  depends_on "cscope"
  depends_on "lua"
  depends_on :macos
  depends_on "python@3.12"
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
    py3_exec_prefix = shell_output(Formula["python@3.12"].opt_libexec/"bin/python-config --exec-prefix")
    assert_match py3_exec_prefix.chomp, output
    (testpath/"commands.vim").write <<~EOS
      :python3 import vim; vim.current.buffer[0] = 'hello python3'
      :wq
    EOS
    system bin/"mvim", "-v", "-T", "dumb", "-s", "commands.vim", "test.txt"
    assert_equal "hello python3", (testpath/"test.txt").read.chomp
  end
end
