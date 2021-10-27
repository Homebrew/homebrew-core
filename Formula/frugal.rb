class Frugal < Formula
  desc "Cross language code generator for creating scalable microservices"
  homepage "https://github.com/Workiva/frugal"
  url "https://github.com/Workiva/frugal/archive/v3.14.10.tar.gz"
  sha256 "982fe4e84aaadbcb04ee5bca2f7859b9e789d172e6b8641dec447246f4567aff"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "289768163cd1ed0bc55a755983db8fc94d15a3fc568154b95f8df7f757670170"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ddf0882cccedf077a47c9d6f19c1149d2deb2f41b9291877b3c74a9021afde64"
    sha256 cellar: :any_skip_relocation, monterey:       "bd003a58e48331c91c9f8798965c3ea2e906d17e9fda70af882a78cda4093c1e"
    sha256 cellar: :any_skip_relocation, big_sur:        "2010feb5c9e7ee315cdb22c94e1ac95336a56a868f553c346f400d297b580db5"
    sha256 cellar: :any_skip_relocation, catalina:       "2010feb5c9e7ee315cdb22c94e1ac95336a56a868f553c346f400d297b580db5"
    sha256 cellar: :any_skip_relocation, mojave:         "2010feb5c9e7ee315cdb22c94e1ac95336a56a868f553c346f400d297b580db5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "19674e735af1211a6f7096df85eb6394c950888496df9d3d035304e87fcf52eb"
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
