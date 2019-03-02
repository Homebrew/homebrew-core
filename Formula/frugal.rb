class Frugal < Formula
  desc "Cross language code generator for creating scalable microservices"
  homepage "https://github.com/Workiva/frugal"
  url "https://github.com/Workiva/frugal/archive/2.28.0.tar.gz"
  sha256 "822506399ba5e619f535b9f06db2da2c3515a1c5de80be6eddc95a4c1881fb90"

  bottle do
    cellar :any_skip_relocation
    sha256 "ae362b55b0c5db5f22819524e0c98e72bbf914ef5ba58f4afcb6736b55bc145b" => :mojave
    sha256 "cd5309f98aca286f9884afb3549bce4fff699feb282ec7c77ec5b13bb255bf9e" => :high_sierra
    sha256 "643ca390eb2ad6e5e494f9a34fb586c42ed45487479960f52bdbe9fc0e2d20e8" => :sierra
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
