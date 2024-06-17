class Csvlens < Formula
  desc "Command-line csv viewer"
  homepage "https://github.com/YS-L/csvlens"
  url "https://github.com/YS-L/csvlens/archive/refs/tags/v0.9.1.tar.gz"
  sha256 "c14626dbcd12d9cf73afb7c012bde9be9b659952ca651c6d331624e6b14a42f6"
  license "MIT"
  head "https://github.com/YS-L/csvlens.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "765a0765bd8827517e4dd6932115a4c3043a95b118401446316c6579aed1c5a6"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d4782dbd224d6dac6558c92692d64a48b2b641517f62d6c0e80c3d5f98735b12"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8601faa7a6547c6a91bde099c69706d5d99cddae7acf79b9509013c827db6851"
    sha256 cellar: :any_skip_relocation, sonoma:         "941cc133af7e6357e81051980a635c564d1d31dcc8dbfc7d2467157980d39c32"
    sha256 cellar: :any_skip_relocation, ventura:        "10535b1d645770ed3c47b9a364548a81e1fb3bbb1912ed2b9a261e92c94b8c33"
    sha256 cellar: :any_skip_relocation, monterey:       "8d31ea7673500cba93b4cc3a910896c899782b683272a413fc563eb917bb0255"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "72e642ba4847da2fe2557aca207d03329cd4d71cfeaa851ea57bc5ddd3360cfb"
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
