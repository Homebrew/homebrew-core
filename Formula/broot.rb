class Broot < Formula
  desc "New way to see and navigate directory trees"
  homepage "https://dystroy.org/broot/"
  url "https://github.com/Canop/broot/archive/v1.11.1.tar.gz"
  sha256 "0cc09d5bcc5c6b80d6161c2ba234df0332c1dabd6c3c9f2f6ebe2f82b8eef5c3"
  license "MIT"
  head "https://github.com/Canop/broot.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6b674cd08f048b83974d34bc9f2546a2d0d617b69adf66df274a884d7b64fec1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ee275f8a987d1fab5517b9a0deb0478c72cc70ccaafb2496b7725bb5e1bdf3bb"
    sha256 cellar: :any_skip_relocation, monterey:       "5dece2eae64c55f08258bf02cf16ebe16185e8113d1f97aa365b703c03437927"
    sha256 cellar: :any_skip_relocation, big_sur:        "50ade0fb9fb30c0f102aa7e351455ea748fc3b475da4598c051bdc4184fad8c3"
    sha256 cellar: :any_skip_relocation, catalina:       "7c8e6d9de3fa5f4d9073b4de7654eeaefd6780e0c1fbd39fe5c5067fa5eacf7e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "579283b2d86835d450d1fc64cb842f0e0ed22fac15148d0936e8fc331390c1f4"
  end

  depends_on "rust" => :build
  depends_on "libxcb"

  uses_from_macos "curl" => :build
  uses_from_macos "zlib"

  def install
    system "cargo", "install", *std_cargo_args

    # Replace man page "#version" and "#date" based on logic in release.sh
    inreplace "man/page" do |s|
      s.gsub! "#version", version
      s.gsub! "#date", time.strftime("%Y/%m/%d")
    end
    man1.install "man/page" => "broot.1"

    # Completion scripts are generated in the crate's build directory,
    # which includes a fingerprint hash. Try to locate it first
    out_dir = Dir["target/release/build/broot-*/out"].first
    bash_completion.install "#{out_dir}/broot.bash"
    bash_completion.install "#{out_dir}/br.bash"
    fish_completion.install "#{out_dir}/broot.fish"
    fish_completion.install "#{out_dir}/br.fish"
    zsh_completion.install "#{out_dir}/_broot"
    zsh_completion.install "#{out_dir}/_br"
  end

  test do
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    assert_match "A tree explorer and a customizable launcher", shell_output("#{bin}/broot --help 2>&1")

    require "pty"
    require "io/console"
    PTY.spawn(bin/"broot", "--cmd", ":pt", "--color", "no", "--out", testpath/"output.txt", err: :out) do |r, w, pid|
      r.winsize = [20, 80] # broot dependency termimad requires width > 2
      w.write "n\r"
      assert_match "New Configuration file written in", r.read
      Process.wait(pid)
    end
    assert_equal 0, $CHILD_STATUS.exitstatus
  end
end
