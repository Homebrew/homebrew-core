class Broot < Formula
  desc "New way to see and navigate directory trees"
  homepage "https://dystroy.org/broot/"
  url "https://github.com/Canop/broot/archive/v1.7.1.tar.gz"
  sha256 "cf4d3d54ca38b022ed030e859e609b80561b38653704dc62bb69d260f84a49e2"
  license "MIT"
  head "https://github.com/Canop/broot.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "bc6b9cc2571cf3fef551bc839befa747d4fdf4d6f5e8b89d4aab05e9e4740537"
    sha256 cellar: :any,                 arm64_big_sur:  "43d0f34ea493b97d08ecfb771620b8bcbc0dad741ac2e490b3020d7814e8c2aa"
    sha256 cellar: :any,                 monterey:       "62d9a60f800cca1f4d2bdac5eb27e86c11979f18fd4b6e37d0ac6705af265e4c"
    sha256 cellar: :any,                 big_sur:        "668ec47dedc70989dc625059e401bca5b3fa2bed071acadc5be6ab8d64d9e66f"
    sha256 cellar: :any,                 catalina:       "eb3c881a61005b523185487ad68f3c2f7b84764285339c6bb1122358f60786fd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "09626818729c2ba4762961945c088377b57101836a9bdded705c8ef6551bd1a7"
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
