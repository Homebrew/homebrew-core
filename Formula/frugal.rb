class Frugal < Formula
  desc "Cross language code generator for creating scalable microservices"
  homepage "https://github.com/Workiva/frugal"
  url "https://github.com/Workiva/frugal/archive/3.3.2.tar.gz"
  sha256 "d29378023e5a62c34be6f522851ef1c1494ba88ecb839701e536ed6720d548a2"

  bottle do
    cellar :any_skip_relocation
    sha256 "82c27e89f33b9f92a1a63c7f884a62c9554d5e4457c623f9dd4482320205eb61" => :mojave
    sha256 "080dd9f7de7991638a2e0928c5ee21826a8b5805ef1cc4a1de14df5e4cfb5c79" => :high_sierra
    sha256 "e6ccb01f9a0a5ee921aee7adc38af9f80ebf32c03c079244bd44343bf762bc3f" => :sierra
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
