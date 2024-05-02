class Csvlens < Formula
  desc "Command-line csv viewer"
  homepage "https://github.com/YS-L/csvlens"
  url "https://github.com/YS-L/csvlens/archive/refs/tags/v0.9.0.tar.gz"
  sha256 "6a2c19d9282cad1c8bc201deb9f3f3d254c9ba43dc6408031a1e3ca5aa05e196"
  license "MIT"
  head "https://github.com/YS-L/csvlens.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "cec6dfcfea759cd686f8e8213797857b067ff4c18241de3d7df833a7bc3bf582"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ccd31d03139ba94a230b7759decefb018b7c888dc42c49c990463ed13a3fef3c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d31390d672d7e7d17c698f2149d937ea240b1efae6126ffefec56718c31a23aa"
    sha256 cellar: :any_skip_relocation, sonoma:         "32ceb4c462039c775249899ed671cefa3ba78ceacf8897bea32093478a81675a"
    sha256 cellar: :any_skip_relocation, ventura:        "dbf30d11eba9fda837933ff9ec28c04c5de2e0cb680082e57207ea66296f6a3c"
    sha256 cellar: :any_skip_relocation, monterey:       "71d476396d4e2f931b79a20a5193280588dcc745fdecfccc4f1f18fd570b51e9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "39dd019b789e2605f648f61ece3f7ff1c426a76687f8a9fd2e18a1f51d06b144"
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
