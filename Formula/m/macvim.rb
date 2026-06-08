# Reference: https://github.com/macvim-dev/macvim/wiki/building
class Macvim < Formula
  desc "GUI for vim, made for macOS"
  homepage "https://github.com/macvim-dev/macvim"
  url "https://github.com/macvim-dev/macvim/archive/refs/tags/release-183.tar.gz"
  version "9.2.0321"
  sha256 "72de6be82087cd4db8d7b5b27ee079fe80d504f12b53065d68d29366fc7025f1"
  license "Vim"
  head "https://github.com/macvim-dev/macvim.git", branch: "master"

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

  no_autobump! because: :incompatible_version_format

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_tahoe:   "f518614c9ee190fb118daffe731cd3d863c72813b0edae39ce769f7127bfb477"
    sha256 cellar: :any, arm64_sequoia: "2fe3d9e559e07493cd4242b8d1af7878b3a35634c6d7d7e685cda86ed0981280"
    sha256 cellar: :any, arm64_sonoma:  "293c2d5e2396c0672b3909bb76a80f4928dedd0d33ccaa4361e79b431586f8f7"
    sha256 cellar: :any, sonoma:        "16e427c43e2708455b2a9812aaba204c627d3275bb860b14f1615d448f7e53b5"
  end

  depends_on "gettext" => :build
  depends_on "libsodium" => :build
  depends_on xcode: :build # for xcodebuild
  depends_on "cscope"
  depends_on "lua"
  depends_on :macos
  depends_on "python@3.14"
  depends_on "ruby"

  conflicts_with "ex-vi", because: "both install `vi` and `view` binaries"
  conflicts_with "vim", "vim-classic", because: "both install vi* binaries"
  conflicts_with cask: "macvim-app"

  def install
    # We don't want the deployment target to include the minor version on Big Sur and newer.
    # https://github.com/Homebrew/homebrew-core/issues/111693
    ENV["MACOSX_DEPLOYMENT_TARGET"] = MacOS.version

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

    # Sign with the correct runtime entitlements
    system "make", "-C", "src", "macvim-signed-adhoc"

    prefix.install "src/MacVim/build/Release/MacVim.app"
    %w[gvimtutor mvim vimtutor xxd].each { |e| bin.install_symlink prefix/"MacVim.app/Contents/bin/#{e}" }

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
    py3_exec_prefix = shell_output("#{Formula["python@3.14"].opt_libexec}/bin/python-config --exec-prefix")
    assert_match py3_exec_prefix.chomp, output
    (testpath/"commands.vim").write <<~VIM
      :python3 import vim; vim.current.buffer[0] = 'hello python3'
      :wq
    VIM
    system bin/"mvim", "-v", "-T", "dumb", "-s", "commands.vim", "test.txt"
    assert_equal "hello python3", (testpath/"test.txt").read.chomp
  end
end
