class Broot < Formula
  desc "New way to see and navigate directory trees"
  homepage "https://dystroy.org/broot/"
  url "https://github.com/Canop/broot/archive/refs/tags/v1.36.1.tar.gz"
  sha256 "b52e60a86e3ca38931cf8ed0ccbd4138f12b733c2459ea3088c267a98b8a555b"
  license "MIT"
  head "https://github.com/Canop/broot.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "44da888434204591307988c4156fec3247c02806fc8d2da7b30ad438fe27d398"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3fc0f7bb88c523dad59253d4862232cef4bf958223af5f410838a19048189330"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "faf69464a339eb81ed7d612e1ef10c22b1e9b56e9f149b735dfbf3f1a3d9c031"
    sha256 cellar: :any_skip_relocation, sonoma:         "b76403753af95f22d949295711d332686871b3d9a2694d67cda0807a16e177b1"
    sha256 cellar: :any_skip_relocation, ventura:        "0e39f2483602f6c195623ee3532d0be977fbddbfcb0c61ef51d0cb5022ef55db"
    sha256 cellar: :any_skip_relocation, monterey:       "66804a5b1f92671a2d40662a1e70946439b257b82aa07eab87e53997f230387f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f8436ae68694438c0e5d635096a4ae0c47d87ea6c14bb6e43b8fbfa909aa143c"
  end

  depends_on "rust" => :build
  depends_on "libxcb"

  uses_from_macos "curl" => :build
  uses_from_macos "zlib"

  def install
    system "cargo", "install", *std_cargo_args

    # Replace man page "#version" and "#date" based on logic in release.sh
    inreplace "man/page" do |s|
      s.gsub! "#version", version.to_s
      s.gsub! "#date", time.strftime("%Y/%m/%d")
    end
    man1.install "man/page" => "broot.1"

    # Completion scripts are generated in the crate's build directory,
    # which includes a fingerprint hash. Try to locate it first
    out_dir = Dir["target/release/build/broot-*/out"].first
    fish_completion.install "#{out_dir}/broot.fish"
    fish_completion.install "#{out_dir}/br.fish"
    zsh_completion.install "#{out_dir}/_broot"
    zsh_completion.install "#{out_dir}/_br"
    # Bash completions are not compatible with Bash 3 so don't use v1 directory.
    # bash: complete: nosort: invalid option name
    # Issue ref: https://github.com/clap-rs/clap/issues/5190
    (share/"bash-completion/completions").install "#{out_dir}/broot.bash" => "broot"
    (share/"bash-completion/completions").install "#{out_dir}/br.bash" => "br"
  end

  test do
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    output = shell_output("#{bin}/broot --help")
    assert_match "lets you explore file hierarchies with a tree-like view", output

    assert_match version.to_s, shell_output("#{bin}/broot --version")

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
