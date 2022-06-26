class Broot < Formula
  desc "New way to see and navigate directory trees"
  homepage "https://dystroy.org/broot/"
  url "https://github.com/Canop/broot/archive/v1.13.1.tar.gz"
  sha256 "95b4b01c43f23b8d4f06030b57c9b2e47a4fbbc4f6099acaf6e42d1f1697385e"
  license "MIT"
  head "https://github.com/Canop/broot.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "089f401e6464a3e61dc2d09492b718628c115102e2fe66baaf4d4936acd8fe54"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "54fe36df295d4518d77ab1d1b9e5fc5a86cb7d2f505f92c6bc67c23dae624f76"
    sha256 cellar: :any_skip_relocation, monterey:       "3a4a98c852d5ebf2be5dda8a1a982d4d59f3bff447eca38b4796b599d016c6d1"
    sha256 cellar: :any_skip_relocation, big_sur:        "4479526a4e39cdbe9a3f1d7703c8c8a657d7bbc6cb249a7c0157a2d7f4f0a023"
    sha256 cellar: :any_skip_relocation, catalina:       "2d6782ad1d0791b27cf471af9cd8ccfd3dc945ae481add2732f1c5d811dc9656"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "998bf7371bcfecdba277ad955b5b0da3d1a807d747b79a5a4fb8d8a32609f429"
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
