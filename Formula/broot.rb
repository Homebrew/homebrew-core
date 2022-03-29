class Broot < Formula
  desc "New way to see and navigate directory trees"
  homepage "https://dystroy.org/broot/"
  url "https://github.com/Canop/broot/archive/v1.9.4.tar.gz"
  sha256 "f1a3cda2ebb3a436b039cb2296914871599305f7f9292cc53d3641a67706fe9f"
  license "MIT"
  head "https://github.com/Canop/broot.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cce878a27d8b8361fcf52eac2869af60d8ee403c93342d2cbb34658883dbcb69"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "cb1383129cd5d56501cc0b4bc274d65fac116cc651ed5e548ecf6935ad8c9b64"
    sha256 cellar: :any_skip_relocation, monterey:       "3fc0b658ae2b0d7c21b6bf45363da542ab66a2e2f6edd821d890ce9cd68d1b6d"
    sha256 cellar: :any_skip_relocation, big_sur:        "255e700733fd5af8954e7acbbceec2dd011db85e13884008a98896349dd8930c"
    sha256 cellar: :any_skip_relocation, catalina:       "372b82625802cce8fd4201f9e397e97813d2db6dabbef66a349dba05fe82bcf5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1ac312b6caebe73995a903ec65acfb2d5194f8e6afba2b2e5eb773daa9d1d224"
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
