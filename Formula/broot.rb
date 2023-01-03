class Broot < Formula
  desc "New way to see and navigate directory trees"
  homepage "https://dystroy.org/broot/"
  url "https://github.com/Canop/broot/archive/v1.19.0.tar.gz"
  sha256 "3345bd0eb17f954212bd12528c476acaa0e4dacb38ad78a047b5aedc2f638c15"
  license "MIT"
  head "https://github.com/Canop/broot.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7864342490d0a72bd4b85511618c4ea55f84de31b45eaf256d63ee0c12c094c3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "caef38176ad29534b6eba0cbab204e6b8177f49e06206f28fd181910235658b7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a093a1f5c78481baa3e5fb04b15f84c7eb61195d5385518f2a3894957df91062"
    sha256 cellar: :any_skip_relocation, ventura:        "17c238a5a5d3b6ed6f29595c8c5028fdd466cb00636059670b3b64c13a2bba64"
    sha256 cellar: :any_skip_relocation, monterey:       "438feca2321fb3e68ad09e95920c1e731fb3512eabbdbc9f25aec42aa19104cd"
    sha256 cellar: :any_skip_relocation, big_sur:        "e4a07baab7592a9eb7d2c9545623368c4db2e3a210958a0bf89acb6c3997f8a5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1d6354be9c784e08ea165e1637a5b32e2e246607800d7ad6f76df808e66e1aa5"
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
