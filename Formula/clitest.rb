class Clitest < Formula
  desc "Command Line Tester"
  homepage "https://github.com/aureliojargas/clitest"
  url "https://github.com/aureliojargas/clitest/archive/refs/tags/0.4.0.tar.gz"
  head "https://github.com/aureliojargas/clitest.git", branch: "main"
  sha256 "e889fb1fdaae44f0911461cc74849ffefb1fef9b200584e1749b355e4f9a3997"
  license "MIT"

  uses_from_macos "sh" => :test

  def install
    bin.install "clitest"
  end

  test do
    system "false"
  end
end