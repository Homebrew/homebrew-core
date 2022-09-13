class Broot < Formula
  desc "New way to see and navigate directory trees"
  homepage "https://dystroy.org/broot/"
  url "https://github.com/Canop/broot/archive/v1.14.3.tar.gz"
  sha256 "fe90cab3f1e966fa8f4bcdd8cb8da10ba6f99413dc0e6ee96e5372089219b375"
  license "MIT"
  head "https://github.com/Canop/broot.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cd9551fbe5d06f4d8135ab14da388f0ab1b1563f87c0c7664f1daea3a497a1b4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "64bb766c75a3ec4aef4af35f86fb2889ef8b6e8ffdb7844adb7a99fc051a3298"
    sha256 cellar: :any_skip_relocation, monterey:       "0a0d2ca68b19d6db4a0ff4d3ef83f3f3b862297401f416c9254053db068b9f3e"
    sha256 cellar: :any_skip_relocation, big_sur:        "723d031140ee91feabd754ecbdd565e6a80b86174b52aaee0dd84f4a41d9ec09"
    sha256 cellar: :any_skip_relocation, catalina:       "eeea92683b58ae57ebb6619ac54af620699f23afee6742e7a0569c7050740482"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "12877ce201e9f4fb97e659e44c5cd3c473d5ab65e10f7b7c69dfe2205a02dab0"
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
