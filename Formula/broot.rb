class Broot < Formula
  desc "New way to see and navigate directory trees"
  homepage "https://dystroy.org/broot/"
  url "https://github.com/Canop/broot/archive/v1.15.0.tar.gz"
  sha256 "a0116a595c175e88e9942331aded44aeab619ceee17297cd912e576483d48e2d"
  license "MIT"
  head "https://github.com/Canop/broot.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f26459b74e886b129653b421aa4e726f8fb1c225b6929c5843217b11a68bb2f0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "43b5a5fc602d866e64158c6ac206df03b2463734c3b3d220c913da92babe4cd5"
    sha256 cellar: :any_skip_relocation, monterey:       "1aa6a0f58bfa7ce8e575dbd2cc7d847a68d92fdcdad177a211b4f61f30392a9b"
    sha256 cellar: :any_skip_relocation, big_sur:        "a21cb06c67023ee8e6e9883bc012a7d7e7858adb1830d8103a7a95882a56ef77"
    sha256 cellar: :any_skip_relocation, catalina:       "e368c986ff9858ada1c26b527d23bb22b0784455b4d66f22884ca534480535e9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bd28471f38752be2f05b014b2e8e20b61cfdda6a2c99dd9d6fc95eaa36877a60"
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
