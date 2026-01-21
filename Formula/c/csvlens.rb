class Csvlens < Formula
  desc "Command-line csv viewer"
  homepage "https://github.com/YS-L/csvlens"
  url "https://github.com/YS-L/csvlens/archive/refs/tags/v0.15.1.tar.gz"
  sha256 "4396cf4e0c51be589f86aed662b9cb03f4f9414d8e2fd80dbc18f20eaf447bb7"
  license "MIT"
  head "https://github.com/YS-L/csvlens.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c11aa18b416fc38eb25df2ec3963fb2c5c300f8979aeba2642ec780865858d34"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dcb4d3a424d61a67bafa876bfc9125dc5a9e582a4fe1acb6c6e51f9112a99247"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f73c7eb50cf7f250e95690a36a1d233a748aaea69e26f3da87526672ee3cffcb"
    sha256 cellar: :any_skip_relocation, sonoma:        "e8f401dec9ed33c0b345b96f5b4c2e454d48dd8c8f84357f7feaecb97754f96c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d8e442634b87705728a3064b56ceffe3100c2b2938ad654ba964c742b351350f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3149de80a4f3bce2c31ddfc8f3db96a8066460a7e4b113f8d3f0a40b4e2a2e42"
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
      sleep 5
      # Select the column B by pressing enter. The answer 42 should be printed out.
      w.write "\r"
      assert r.read.end_with?("42\r\n")
    rescue Errno::EIO
      # GNU/Linux raises EIO when read is done on closed pty
    end
  end
end
