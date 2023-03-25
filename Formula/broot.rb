class Broot < Formula
  desc "New way to see and navigate directory trees"
  homepage "https://dystroy.org/broot/"
  url "https://github.com/Canop/broot/archive/v1.21.1.tar.gz"
  sha256 "0234311ee205ce71fa9ce96c72531495094a485e921dcf0fa29915d88dce3ef2"
  license "MIT"
  head "https://github.com/Canop/broot.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "09e303b743debed6fc08c7182a179d04690e35453cdae01116a39f63c7a589d8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "622579929ae3efd1e828f3af09e576dd0b2b8726ed472de7511b4addc3b30c65"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "eb7daaecf7a0cf9ee0030a1edc28932a02bc83ffdb1141cc01b2e074ebe7b25b"
    sha256 cellar: :any_skip_relocation, ventura:        "548b0a2304d41438f26c1799ab1ae596e66701dd1fbb86d971e37c2bf8629f5f"
    sha256 cellar: :any_skip_relocation, monterey:       "a95851443197373090f3b162ae609b65760a42b42ed709d9012e1f7ecc17da58"
    sha256 cellar: :any_skip_relocation, big_sur:        "b26bda96fb5a796a60409689a6d96046ecf0f32d894de80047ba45310afcbce2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8490a16a0b419812d74a3cc4cf7ede34f20c66379d6943828c39d7286ee531fe"
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
    PTY.spawn(bin/"broot", "-c", ":print_tree", "--color", "no", "--outcmd", testpath/"output.txt",
                err: :out) do |r, w, pid|
      r.winsize = [20, 80] # broot dependency terminal requires width > 2
      w.write "n\r"
      assert_match "New Configuration files written in", r.read
      Process.wait(pid)
    end
    assert_equal 0, $CHILD_STATUS.exitstatus
  end
end
