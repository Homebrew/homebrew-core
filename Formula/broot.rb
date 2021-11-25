class Broot < Formula
  desc "New way to see and navigate directory trees"
  homepage "https://dystroy.org/broot/"
  url "https://github.com/Canop/broot/archive/v1.7.3.tar.gz"
  sha256 "32888e8e14f2e328e7597276eb1c2f7194cd955e2fd66de456294a69b9f508d0"
  license "MIT"
  head "https://github.com/Canop/broot.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "8da47ba3b6ed80196c115e94dadf820bf16a8c132ebd7070387116570afbfde2"
    sha256 cellar: :any,                 arm64_big_sur:  "874fb1dd2e8165e427ee467cf0b854249a35f8ad17d6e1d1ad7fdc4b8e712035"
    sha256 cellar: :any,                 monterey:       "af2f19a27a9e4e67358aadeb8807bbdb37eba1efa4b4bd463ab81823ee20d115"
    sha256 cellar: :any,                 big_sur:        "809504ca67d012ed75f827384a8ab9eee11a71d3a803e1628acd3ec347c63bb5"
    sha256 cellar: :any,                 catalina:       "3a7d33f67c4538e2cea40227adfbe7f9c7bc1dacd2c40ce3f7ba10cc349c1ae4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d1c5a06b2664ba3b4493cad537358b5aca19b4c59d7230ee80453677a2146ef5"
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
