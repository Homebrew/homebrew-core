class Frugal < Formula
  desc "Cross language code generator for creating scalable microservices"
  homepage "https://github.com/Workiva/frugal"
  url "https://github.com/Workiva/frugal/archive/v3.14.3.tar.gz"
  sha256 "875f5a3faaee153c84d85ecd213fc833fa5601867310bd7b983065ececc2c2c1"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "ac5149308798a4a55d01818373525d46ccd996c301ea7329a670e983350ee5d6"
    sha256 cellar: :any_skip_relocation, big_sur:       "ae388f2aef1545924508d4e59adbfe3e86e4c1ad40fc016020273b8cbea5825a"
    sha256 cellar: :any_skip_relocation, catalina:      "8317d00269934a4ba7e233826000b3b6bdc6b05e34fe7aebc8c35491c42e182d"
    sha256 cellar: :any_skip_relocation, mojave:        "5f1baf3635e5bbfdb71d31717799a0c1afc6f4e1cfc77d7ab6f3370bc2419ed7"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "-ldflags", "-s -w"
  end

  test do
    (testpath/"test.frugal").write("typedef double Test")
    system "#{bin}/frugal", "--gen", "go", "test.frugal"
    assert_match "type Test float64", (testpath/"gen-go/test/f_types.go").read
  end
end
