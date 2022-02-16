class Broot < Formula
  desc "New way to see and navigate directory trees"
  homepage "https://dystroy.org/broot/"
  url "https://github.com/Canop/broot/archive/v1.9.3.tar.gz"
  sha256 "1034905ba031cd2b77f32e42835e228ae76f10005829e24ed0ad1035d12a6c4b"
  license "MIT"
  head "https://github.com/Canop/broot.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bc6be6446bbc40041fa7c3f1f6b0794d4e155f58072dfb6236903b3600423688"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a3ca8013e5a5d7ce983b4a358ad7dcd21978507fc84e42c20fe040fb51208c16"
    sha256 cellar: :any_skip_relocation, monterey:       "2044f0faa585b806009772ff26639e85e98cf44940b84b5a292569b52b482501"
    sha256 cellar: :any_skip_relocation, big_sur:        "79a0bbdccc6fadea4798440871851d6052b5e8f827c045f1024d744ea870635c"
    sha256 cellar: :any_skip_relocation, catalina:       "7a25272b2fdcb344bf80e0b991686a893e615a1ba56b227f00980008dbd47ad1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "344c278a5dd7e29adba54a60559bce20cdd07af20e8200005ca34d1b1fe555ca"
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
    on_linux do
      return if ENV["HOMEBREW_GITHUB_ACTIONS"]
    end

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
