# Reference: https://github.com/macvim-dev/macvim/wiki/building
class Macvim < Formula
  desc "GUI for vim, made for macOS"
  homepage "https://github.com/macvim-dev/macvim"
  url "https://github.com/macvim-dev/macvim/archive/refs/tags/release-180.tar.gz"
  version "9.1.0727"
  sha256 "e1bc74beb3ee594503b5e1e20a9d075b5972bbaa642a91921116531475f46a6f"
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

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_sequoia: "80e6eed701a2a90d774c3466a1a658eae0602f6514cc179cf5f4094a4a59536f"
    sha256 cellar: :any, arm64_sonoma:  "0f73e511af34cbe4477d83c907e9b42caf8032b8b2723fc5879d68f00e861dea"
    sha256 cellar: :any, arm64_ventura: "e9210bbe26673e2cefc2445636b5b1f4a42e1f19369a4aa64071f7a721680b77"
    sha256 cellar: :any, sonoma:        "eee7dada958ef31d41d97838efce0689d8aac95adb7a782f16ca3147348fbe49"
    sha256 cellar: :any, ventura:       "663fb344c7d5e0e73373204a8ba3ebf61e348c8b638791340e985a86e62f8961"
  end

  depends_on "gettext" => :build
  depends_on "libsodium" => :build
  depends_on xcode: :build # for xcodebuild
  depends_on "cscope"
  depends_on "lua"
  depends_on :macos
  depends_on "python@3.13"
  depends_on "ruby"

  conflicts_with "ex-vi", because: "both install `vi` and `view` binaries"
  conflicts_with "vim", because: "both install vi* binaries"

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
    py3_exec_prefix = shell_output(Formula["python@3.13"].opt_libexec/"bin/python-config --exec-prefix")
    assert_match py3_exec_prefix.chomp, output
    (testpath/"commands.vim").write <<~EOS
      :python3 import vim; vim.current.buffer[0] = 'hello python3'
      :wq
    EOS
    system bin/"mvim", "-v", "-T", "dumb", "-s", "commands.vim", "test.txt"
    assert_equal "hello python3", (testpath/"test.txt").read.chomp
  end
end
