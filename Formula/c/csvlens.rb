class Csvlens < Formula
  desc "Command-line csv viewer"
  homepage "https://github.com/YS-L/csvlens"
  url "https://github.com/YS-L/csvlens/archive/refs/tags/v0.8.0.tar.gz"
  sha256 "1e0fd4493dddd108707e75e70195c83ed7e39008254584396b6139b1d21aa982"
  license "MIT"
  head "https://github.com/YS-L/csvlens.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "aa633b7eb513eb1b46607fc9ae2df72279db648e63f4daf2a7bb429f76048943"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b24d0f138b4e7ceac21815116dc970ffbb7bf28aa4917b75b29da6de20ca39fa"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d59d43d0720c78067f6a0a8ece7e2e7c356848cc64e5513646a192948f016c0e"
    sha256 cellar: :any_skip_relocation, sonoma:         "3ca202cadb88dc057ac9f573705c577b2c5042789bde428d74e6513383fee0f3"
    sha256 cellar: :any_skip_relocation, ventura:        "9e599d0128dfcba1a8d67a90371debcc6252ffa4d97ad1a8ca98c734740be79c"
    sha256 cellar: :any_skip_relocation, monterey:       "e18baab1d62218f32b06afa8019bb0442556e976e69e9121a2c1d7d415434506"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "969f326d810c5dad6d6cfe9170a6680998ea2d906bf6586a1743fa881c257e43"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    require "pty"
    require "io/console"
    (testpath/"test.csv").write("A,B,C\n100,42,300")
    PTY.spawn(bin/"csvlens", "#{testpath}/test.csv", "--echo-column", "B") do |r, w, _pid|
      r.winsize = [10, 10]
      sleep 1
      # Select the column B by pressing enter. The answer 42 should be printed out.
      w.write "\r"
      assert r.read.end_with?("42\r\n")
    rescue Errno::EIO
      # GNU/Linux raises EIO when read is done on closed pty
    end
  end
end
