class Csvlens < Formula
  desc "Command-line csv viewer"
  homepage "https://github.com/YS-L/csvlens"
  url "https://github.com/YS-L/csvlens/archive/refs/tags/v0.10.1.tar.gz"
  sha256 "7d9062fa94a67fec121062bd45efb00a40bf26236f3cc635ec0945793344e097"
  license "MIT"
  head "https://github.com/YS-L/csvlens.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e15ca33c987cfa9e2649aa3a374b3f323c6de6cf000a6e8960fed4e7b743672c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b124b4af51bd667998443544ccd19e53a9ce7a8f371b8b50dab154d45f00bc58"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "140f8a7589e47ffb645d660e728287809e7be34241b6c4d5eb24edd8c156aee2"
    sha256 cellar: :any_skip_relocation, sonoma:        "54306a793ddaba7cc4c44857d22ad274b2c5fb405f114327211f0fd81a76c3f9"
    sha256 cellar: :any_skip_relocation, ventura:       "44ad684fc850eac40a85de7da11d6e00f68513ff302d84b6975f05357ef0aa5a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "74cc0a74db62274d21f53a9c10d01bb459ef266f138eb49e0d86f2c2db612f99"
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
