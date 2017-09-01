class Frugal < Formula
  desc "Cross language code generator for creating scalable microservices"
  homepage "https://github.com/Workiva/frugal"
  url "https://github.com/Workiva/frugal/archive/2.9.1.tar.gz"
  sha256 "5cd9179007b726517e64bccdd7873b229f8cd6e1d3d2da21e48b4ce347f61386"

  bottle do
    cellar :any_skip_relocation
    sha256 "25d507cdc5236d6c4bc82833ef620c81687e37c88a064db8c340e5f146c22de8" => :sierra
    sha256 "699d4d64b3b729d265efe3d355f4e83834c30e8023cdd44b688db0658d21292a" => :el_capitan
    sha256 "c7aa38ac392ea883422a74e1834084d19969c821f4224bb4d9451ddaec40546c" => :yosemite
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
