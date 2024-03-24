class Csvlens < Formula
  desc "Command-line csv viewer"
  homepage "https://github.com/YS-L/csvlens"
  url "https://github.com/YS-L/csvlens/archive/refs/tags/v0.8.0.tar.gz"
  sha256 "1e0fd4493dddd108707e75e70195c83ed7e39008254584396b6139b1d21aa982"
  license "MIT"
  head "https://github.com/YS-L/csvlens.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f7b109626f6733f2435538ddbce29dea56eb351533ee717ca4775c65d876e4e8"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5e166a1616f5d0304b446ebe332be60850a19d53f111a00474705dfeafa76bf6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2442e5afc8aa590f962113f3db851f1c384651db0ffd03b79d175fb1bf335d95"
    sha256 cellar: :any_skip_relocation, sonoma:         "edcb6f11630d182babfe92a768001226d03577109f09234f788510275f2137b0"
    sha256 cellar: :any_skip_relocation, ventura:        "aac8d2498cbbab6d2f5b48b3d1838bd7d41f5855a080b0a6c5e8bea6ee300732"
    sha256 cellar: :any_skip_relocation, monterey:       "44d10c5b3d1f06c8bfdf1c818837a9bbb327664b1f9084dea37a60e8d4779577"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1acca2211a9fe3a2ad1898c136bc1c5287624ac8c357197027ab458a9038bad7"
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
