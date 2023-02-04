class Kush < Formula
  desc "Cross-platform command-line SSH remote address connection tool"
  homepage "https://github.com/anigkus/kush"
  url "https://github.com/anigkus/kush/archive/refs/tags/v0.0.9.tar.gz"
  sha256 "c716330383a1f4710078928951d29e7f0f05bf143162dcabe37b35db453a691d"
  license "Apache-2.0"
  head "https://github.com/anigkus/kush.git"
  depends_on "go" => :build
  def install
    system "go", "build", "-ldflags=-s -w", "-o", "build/darwin/kush"
  end
  test do
    system "false"
  end
end
