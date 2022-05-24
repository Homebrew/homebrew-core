class Broot < Formula
  desc "New way to see and navigate directory trees"
  homepage "https://dystroy.org/broot/"
  url "https://github.com/Canop/broot/archive/v1.12.0.tar.gz"
  sha256 "94b5bc7fa79f379c2c23c23402e7a076495b4d23ca7d89e4631702dbff15fb82"
  license "MIT"
  head "https://github.com/Canop/broot.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "be000a80dd9a49027a9df949ec28e32b575e0f91acb05d47a218b8247711d080"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6298ef9b08b39ea02651c171f275cc536ca5f3dfb025b3fa78951ce656e926d7"
    sha256 cellar: :any_skip_relocation, monterey:       "a749ae15032114ce760cc8c4096b79cf2ce6b1607edf1e1313ce0895dba8c81d"
    sha256 cellar: :any_skip_relocation, big_sur:        "e6c38089743b62ed642bd5ace7d5bada75b7dc079351b2f1926209a09aa0aaab"
    sha256 cellar: :any_skip_relocation, catalina:       "c32447fb020fce14b72bfaa426da2b8a444b7965f5b7179b1179590649e8be8c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ce030b1ccbccfb0df379edc78938927f49917dce6c5d1516b601eb5196540bfd"
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
