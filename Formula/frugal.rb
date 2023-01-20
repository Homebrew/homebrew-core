class Frugal < Formula
  desc "Cross language code generator for creating scalable microservices"
  homepage "https://github.com/Workiva/frugal"
  url "https://github.com/Workiva/frugal/archive/v3.16.13.tar.gz"
  sha256 "c403995e18aa379c2ccc7e9de3e16f15ad85d2e65fe3d60c818a88c26a0d1646"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e342b9f33fb9dfcae6523c6ac126080303e4b1879094279cd602f8af67afead6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c80b8c2a03a4263b461a46cf69f33f2aaa123a2803d4e1e301ed1e7e1f26ec3d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "46d3c47fd51d9ed59a78a9c11de030f9ae6165908410573c7609f0306b3c1307"
    sha256 cellar: :any_skip_relocation, ventura:        "98586eba402affde268896261f7b344854edcf501d41542dd1fc6098df94f45b"
    sha256 cellar: :any_skip_relocation, monterey:       "fa47032ca13178a286100233eb77f7905c37f33d82379943086f6eca6f34532a"
    sha256 cellar: :any_skip_relocation, big_sur:        "1677c5b8cddd11bbfd4379cbea4af1b1e14a0912647532d11f03f13e8bf56abf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3cf6c5403934f7d1e4957498929d91f7dcdf38805adfec9c24447ac48966244f"
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
