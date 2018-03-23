class Frugal < Formula
  desc "Cross language code generator for creating scalable microservices"
  homepage "https://github.com/Workiva/frugal"
  url "https://github.com/Workiva/frugal/archive/2.16.0.tar.gz"
  sha256 "5c7dce490ad275f02247f087900a3050d421cd3cdf25d1f3264ed10e62e383c4"

  bottle do
    cellar :any_skip_relocation
    sha256 "7e54ffb936e2f07d0fcf59c985384a11c9bd6b3683daa04cc2b3984e3966d30c" => :high_sierra
    sha256 "0c68229e57cca0956a50076f235bc27204897ed8eb8d2c63ce24e4953b03debc" => :sierra
    sha256 "41e2326ee520ce097b168ea0013ae33e5dc2df771f36cce15e8a49532bd05da9" => :el_capitan
  end

  depends_on "go" => :build
  depends_on "godep" => :build

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/Workiva/frugal").install buildpath.children
    cd buildpath/"src/github.com/Workiva/frugal" do
      system "godep", "restore"
      system "go", "build", "-o", bin/"frugal"
      prefix.install_metafiles
    end
  end

  test do
    (testpath/"test.frugal").write("typedef double Test")
    system "#{bin}/frugal", "--gen", "go", "test.frugal"
    assert_match "type Test float64", (testpath/"gen-go/test/f_types.go").read
  end
end
