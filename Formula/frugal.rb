class Frugal < Formula
  desc "Cross language code generator for creating scalable microservices"
  homepage "https://github.com/Workiva/frugal"
  url "https://github.com/Workiva/frugal/archive/2.24.0.tar.gz"
  sha256 "bc236864b044b333c5398a44a39cee080494f85370815aa3dbc3c86400d90e58"

  bottle do
    cellar :any_skip_relocation
    sha256 "bfeb0c731fb74b75d954cddecd8636fc9f1948974d3e638d8c919c46ab1f9960" => :mojave
    sha256 "c752b710fdd1862ed9a82503db1e5d74d7d8bfec9bbd14ad9acf566fbf86ed0e" => :high_sierra
    sha256 "20222f4a456ce39e09f4202a4e20a41f93a362de21421abdcc68b247c10a0865" => :sierra
  end

  depends_on "glide" => :build
  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/Workiva/frugal").install buildpath.children
    cd "src/github.com/Workiva/frugal" do
      system "glide", "install"
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
