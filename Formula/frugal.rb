class Frugal < Formula
  desc "Cross language code generator for creating scalable microservices"
  homepage "https://github.com/Workiva/frugal"
  url "https://github.com/Workiva/frugal/archive/v3.4.11.tar.gz"
  sha256 "7d10e8e9953d472ea1fb62f0e526b3112c7e23877454aefc122081fffe9bdce3"

  bottle do
    cellar :any_skip_relocation
    sha256 "35bce17ddf806cf7c9170af302c2940799974ef1ecec2ebc4061f848a631ebd9" => :catalina
    sha256 "0870926f0726800066d9844ac78dd2c0e110f7366455d4d18b4a2d8da51cb1eb" => :mojave
    sha256 "3eab07531f450e026dc14b54fffb5e9fca5ee718053cddc29aa713ab027bba2b" => :high_sierra
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
