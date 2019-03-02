class Frugal < Formula
  desc "Cross language code generator for creating scalable microservices"
  homepage "https://github.com/Workiva/frugal"
  url "https://github.com/Workiva/frugal/archive/2.28.0.tar.gz"
  sha256 "822506399ba5e619f535b9f06db2da2c3515a1c5de80be6eddc95a4c1881fb90"

  bottle do
    cellar :any_skip_relocation
    sha256 "1484956fae08de184fc9815d19e9277c0647686fb45ce0d4154ae746fcefb10f" => :mojave
    sha256 "88b63594e66e411239f4041f5e4febc24c6af3d496d8cf8c5ca76eb85e709e3a" => :high_sierra
    sha256 "297efa1ba15e3a6ff1ee4e3ec241459187ead933f574eb280b41146d16947525" => :sierra
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
