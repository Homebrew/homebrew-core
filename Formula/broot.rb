class Broot < Formula
  desc "New way to see and navigate directory trees"
  homepage "https://dystroy.org/broot/"
  url "https://github.com/Canop/broot/archive/v1.6.4.tar.gz"
  sha256 "609bd9e6c7fea85b68586435280b37cb90c2af3cb0a3f63a5a37dfdcc822fdc7"
  license "MIT"
  head "https://github.com/Canop/broot.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "76c0ce8c6a5da128401bc3995524a07a360a075779a7d26a3a526fbd26004fec"
    sha256 cellar: :any_skip_relocation, big_sur:       "6f16ac65f8a9b27a21db5b1fb38049ad9b5d243832927574bfe78b825221421c"
    sha256 cellar: :any_skip_relocation, catalina:      "75b055853c97b9ff18c23595686beeeeaa7e3cbfc5af6b64eedc6a497e839c1d"
    sha256 cellar: :any_skip_relocation, mojave:        "807051360e34a92cce8c261261141674c14570b697796a72cbc8db5be59b8e1d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f395a2003f2d70a6ee4c08bf95977c9a617895aec8d67320f3f0007d948be4f9"
  end

  depends_on "rust" => :build

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
