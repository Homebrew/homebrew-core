class Frugal < Formula
  desc "Cross language code generator for creating scalable microservices"
  homepage "https://github.com/Workiva/frugal"
  url "https://github.com/Workiva/frugal/archive/refs/tags/v3.17.5.tar.gz"
  sha256 "bf9d5e554ed72beffe0a88a6b5bdc0fbf81771edeba768315d8079e6296ae66e"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3fec5c56e2e35df0cf5c8c8620aed81558eb118402573d125270d4ac5bfa936c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "62259103d5ee8ae54a97612a09ba7fb979794d23c8adb5348288af4eaca256b3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "300a597a17f7082032ca2e82eb3f0e75491cdeec06f62b31941e800927b0372f"
    sha256 cellar: :any_skip_relocation, sonoma:         "dd24259a445d25a272846b74c4b0b97a3c7e9b9ee93e2021a7ced6fa972c9e4d"
    sha256 cellar: :any_skip_relocation, ventura:        "19eec3806810a6fb68f5fa0cd7a34b967212c7d451f4571279d96ebc3894a37a"
    sha256 cellar: :any_skip_relocation, monterey:       "87bb99bbdc6ca05f0eae831b24ee1ac7797280a3ece26fdfbb6a06c2ade4c618"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6f2b3cf06a772c07a6c7b03043268036f588a994ffac7ed66ed76e7e6c60e848"
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
