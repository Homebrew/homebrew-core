class Frugal < Formula
  desc "Cross language code generator for creating scalable microservices"
  homepage "https://github.com/Workiva/frugal"
  url "https://github.com/Workiva/frugal/archive/v3.14.6.tar.gz"
  sha256 "325f98d15f9aa47161ae761a272d3787bb1921384aa30899fbe71fe41ebd21e1"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "df1aadb5fa29222b49837bba1c35bf1aeb352f7692d2ad7df62141726d87ff5d"
    sha256 cellar: :any_skip_relocation, big_sur:       "131c981d87e208ef8f68215af80b35819bb203d11039aedb0bf663c604b01e85"
    sha256 cellar: :any_skip_relocation, catalina:      "131c981d87e208ef8f68215af80b35819bb203d11039aedb0bf663c604b01e85"
    sha256 cellar: :any_skip_relocation, mojave:        "131c981d87e208ef8f68215af80b35819bb203d11039aedb0bf663c604b01e85"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0dc5c5873cc4c18aa3552fcb47980ecf80e2a590289f0ce79f1a699f4aab3aa3"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    (testpath/"test.frugal").write("typedef double Test")
    system "#{bin}/frugal", "--gen", "go", "test.frugal"
    assert_match "type Test float64", (testpath/"gen-go/test/f_types.go").read
  end
end
