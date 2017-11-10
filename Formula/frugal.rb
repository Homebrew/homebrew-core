class Frugal < Formula
  desc "Cross language code generator for creating scalable microservices"
  homepage "https://github.com/Workiva/frugal"
  url "https://github.com/Workiva/frugal/archive/2.13.0.tar.gz"
  sha256 "a8dc3d91409c36a8efd1c0e94329f79ecf5c93c6f85edd130b0f18695ca96c7e"

  bottle do
    cellar :any_skip_relocation
    sha256 "8a62bd838948efb98079ebd7e52878581985a3b34348d9a09a13f7784f52659f" => :high_sierra
    sha256 "5ea9410bedbec3d19f700fd5fa6593a7b68fec10ed3c8c4f5ae8b5b7d1178911" => :sierra
    sha256 "8acc48dd41f782a2dca694c77ffd7a987a9e65ce8edec0097c39dca434b8c60a" => :el_capitan
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
