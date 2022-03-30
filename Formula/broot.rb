class Broot < Formula
  desc "New way to see and navigate directory trees"
  homepage "https://dystroy.org/broot/"
  url "https://github.com/Canop/broot/archive/v1.10.0.tar.gz"
  sha256 "0ec905b45dc58624e473e2b3f84951ab7afadde6dd9bdb72f190ab97e86af22d"
  license "MIT"
  head "https://github.com/Canop/broot.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "94854882f96f9812c817d67b8970e96cf92bb3d1a81fc60b74133070f30ee1d6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8e78421864c93158214082719c6ea0e897cde095d5a0fbf6e6ffda846506bbd3"
    sha256 cellar: :any_skip_relocation, monterey:       "b8b5bed371c2b0bdb1d64f651c8d985b44348c2eb7777327186a731f14d61955"
    sha256 cellar: :any_skip_relocation, big_sur:        "831614afbbc2290088bb52d2ffe03bf17d86967456200244690e7c6223cb4991"
    sha256 cellar: :any_skip_relocation, catalina:       "f461070395a618d2fd4cf5e6fbfe4c67a1b790f30e2657433a8d2a49a9349c21"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a5f0a506f1202eb5a8698b861fd96f85c84c84a9179eb078f00bbb2f19efc8b8"
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
