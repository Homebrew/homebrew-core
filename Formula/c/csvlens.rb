class Csvlens < Formula
  desc "Command-line csv viewer"
  homepage "https://github.com/YS-L/csvlens"
  url "https://github.com/YS-L/csvlens/archive/refs/tags/v0.8.1.tar.gz"
  sha256 "3376f96ee5f6722efc51a7d595dc5ca2dae6894050560cd3c6fe04488dfd10d4"
  license "MIT"
  head "https://github.com/YS-L/csvlens.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9372bb11e30c3cfcc881706c4dd0b181516aa87b37094d87f0f50fb7c7aa7aa4"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "449974f3cb6ea9cb4b5eb2b03685e62bdccc1ac77879bf4cf93a08c13517cbe9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f1f84ecc2a95a06d84ec46417bd10690bbc6ba8e98c401d82e125bdce56b7eb5"
    sha256 cellar: :any_skip_relocation, sonoma:         "7223393a61d740183f34a55e74d672a68625f1e6899ea9d9d61c8ae6adfdaf8b"
    sha256 cellar: :any_skip_relocation, ventura:        "4d151151569a1b75781ec0f32fa5b08514e3188982c81d1e925fbf9fac680cc8"
    sha256 cellar: :any_skip_relocation, monterey:       "49d99498713e281f58aa4a941c11928c651066deaa2046c05397a7f92b9a5a12"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "67e4afb5758fa82748a1b55f7785b329240fbe8d23d91dfb5a11c601e3cfbb34"
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
