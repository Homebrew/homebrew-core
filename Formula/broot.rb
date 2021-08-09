class Broot < Formula
  desc "New way to see and navigate directory trees"
  homepage "https://dystroy.org/broot/"
  url "https://github.com/Canop/broot/archive/v1.6.3.tar.gz"
  sha256 "c7ef696a9da162a4338790a9e021eddedcc9a5be321bfea5cc2c33b2b2a53472"
  license "MIT"
  head "https://github.com/Canop/broot.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "3cff2cf84e7a32b908b85701ea06c6f92e19e25db0e9344b694065816d53cc22"
    sha256 cellar: :any_skip_relocation, big_sur:       "c6b99746eaef474cfe50304cada0292548a01a03d5a1d3bdbd2e4087d4d8b036"
    sha256 cellar: :any_skip_relocation, catalina:      "75ecb00808ead30aecf941609b2f77e584c1b787e9f68d24446bc8231a71f5e7"
    sha256 cellar: :any_skip_relocation, mojave:        "072e7cf407b955b79fd69ca00f224aabcdaba3268cca6ec58663179b669c88b0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f745b17e4311f7aa9a5e59615af3217bd1b1aca852bbab5c97bb6d1a047c8ab1"
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
