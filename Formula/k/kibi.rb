class Kibi < Formula
  desc "Text editor in ≤1024 lines of code, written in Rust"
  homepage "https://github.com/ilai-deutel/kibi"
  url "https://github.com/ilai-deutel/kibi/archive/refs/tags/v0.3.3.tar.gz"
  sha256 "a7a7b6f6937f39ae86fd4f556034a3744bb99091c102bc6f38b281ee751d10e9"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bb06d019acc78dbbe42b1f3859743ca1d516eb54cf54a72229aaeb5ee62aacc3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "85d1fad82e87446f839686a6ee90533134fb949813bba8cbb04a583294d85201"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d51186943ed5638a037531ce219bfbc10be39e969cbdb2a11e355f06f0c75aa0"
    sha256 cellar: :any_skip_relocation, sonoma:        "2aa697080d2ca9d9f7d66d979cbe2fdeb18a06c724cf4dcf546a0e545342b432"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3852d8aa7f19bdea039b6b82944b8de02cba83deebbf86e291977aaba780f6ca"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "25f6258f4378e983e8272f46106fd76caa30914eb5f6a7eb990a7b05b83cfdb7"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    PTY.spawn(bin/"kibi", "test.txt") do |r, w, _pid|
      r.winsize = [80, 43]
      sleep 1
      w.write "test data"
      sleep 1
      w.write "\u0013" # Ctrl + S
      sleep 1
      w.write "\u0011" # Ctrl + Q
      sleep 1
      begin
        r.read
      rescue Errno::EIO
        # GNU/Linux raises EIO when read is done on closed pty
      end
    end

    sleep 1
    assert_match "test data", (testpath/"test.txt").read
  end
end
