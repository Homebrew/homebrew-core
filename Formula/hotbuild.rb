class Hotbuild < Formula
  desc "Cross platfrom hot compilation tool for go"
  homepage "https://hotbuild.ffactory.org"
  url "https://github.com/wandercn/hotbuild/archive/refs/tags/v1.0.7.tar.gz"
  sha256 "22d5feb6771ca1ba668b5371e0dccf06c4b201a41ac42a0651403e2798d68386"
  license "GPL-3.0-only"
  depends_on "go" => :build
  def install
    system "go", "build", *std_go_args
  end
  test do
    system "hotbuild"
  end
end
