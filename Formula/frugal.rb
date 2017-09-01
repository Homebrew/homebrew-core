class Frugal < Formula
  desc "Cross language code generator for creating scalable microservices"
  homepage "https://github.com/Workiva/frugal"
  url "https://github.com/Workiva/frugal/archive/2.9.1.tar.gz"
  sha256 "5cd9179007b726517e64bccdd7873b229f8cd6e1d3d2da21e48b4ce347f61386"

  bottle do
    cellar :any_skip_relocation
    sha256 "3042e3efa48bab9443569f13cedc01dae09bb8ae35852899567b6a195f9b2f98" => :sierra
    sha256 "3f0b5a2b35a10b2171666bbee4ba3e656425cd7c78a6b63116f49bcea6de3d83" => :el_capitan
    sha256 "e73d547528635e521a8af878748220b345545eaf4ce166172f3a89ec875c4a32" => :yosemite
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
