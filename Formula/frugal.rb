class Frugal < Formula
  desc "Cross language code generator for creating scalable microservices"
  homepage "https://github.com/Workiva/frugal"
  url "https://github.com/Workiva/frugal/archive/v3.14.9.tar.gz"
  sha256 "223afe9aab415308a0cb83bb71f51d5868c0ec180401146d1dfb107ea6d0650b"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "ddf0882cccedf077a47c9d6f19c1149d2deb2f41b9291877b3c74a9021afde64"
    sha256 cellar: :any_skip_relocation, big_sur:       "2010feb5c9e7ee315cdb22c94e1ac95336a56a868f553c346f400d297b580db5"
    sha256 cellar: :any_skip_relocation, catalina:      "2010feb5c9e7ee315cdb22c94e1ac95336a56a868f553c346f400d297b580db5"
    sha256 cellar: :any_skip_relocation, mojave:        "2010feb5c9e7ee315cdb22c94e1ac95336a56a868f553c346f400d297b580db5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "19674e735af1211a6f7096df85eb6394c950888496df9d3d035304e87fcf52eb"
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
