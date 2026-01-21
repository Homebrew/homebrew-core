class Kibi < Formula
  desc "Text editor in ≤1024 lines of code, written in Rust"
  homepage "https://github.com/ilai-deutel/kibi"
  url "https://github.com/ilai-deutel/kibi/archive/refs/tags/v0.3.2.tar.gz"
  sha256 "150fde4664ebe47a4c588cf8ff2583392c76038339982a7180ee9282ce6c3cf2"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cdb7d21b2b3f61e993b2a2a8f4659802c1eef433d21034371eaab8da6f438d88"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8b4719f8ad7d488ad3e5b5aebd7f22307812648939905770e40b5f3959f9182c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "93b40c96fc49471d9471cfc394445a7c6c13cb98050aaadf33f6c29d84b47cb5"
    sha256 cellar: :any_skip_relocation, sonoma:        "38d3c353a71abec7eab726eeff37fbffe95182ef5bd86bb4e7802a700a81fff4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "90ff945a7cbd57e54ec582d539b98760ffad2722a0541b5a9551685b66f2d6c2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a9215e2c6557bf575833051f3dbf83092089d82f5850421621a6dd19c7248ebc"
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
