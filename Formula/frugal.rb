class Frugal < Formula
  desc "Cross language code generator for creating scalable microservices"
  homepage "https://github.com/Workiva/frugal"
  url "https://github.com/Workiva/frugal/archive/v3.9.2.tar.gz"
  sha256 "d5cd8406c49193649fa2fd6fb49877de00fe7abf7a69c2fd011caf0384e24c2d"

  bottle do
    cellar :any_skip_relocation
    sha256 "6ffd7c31d222adfc65015a2b52a35508989ccb49e2f4072c0d51d86e319911bf" => :catalina
    sha256 "ecdbd7318645f0aa4868d227b607cf8bb6bfb15a2a6c28194ad4bb6a302a1e4a" => :mojave
    sha256 "588b9d7b2ac73b0caf9c2ec293622ccd9a562d299b8f23daec51c719cf878963" => :high_sierra
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
