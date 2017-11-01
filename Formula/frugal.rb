class Frugal < Formula
  desc "Cross language code generator for creating scalable microservices"
  homepage "https://github.com/Workiva/frugal"
  url "https://github.com/Workiva/frugal/archive/2.12.0.tar.gz"
  sha256 "d59d9014a97cfce3ec5c5c751fb791c604edabbafd73e1499fd2a535dac013bf"

  bottle do
    cellar :any_skip_relocation
    sha256 "00dd10952a7f238a1b3811af85d07996801c02343f9734f1cd49733519de1250" => :high_sierra
    sha256 "b0b585060ab89567f8e5a9cd5fb94ad78d5b11434e5ae7d82e808f627e787e65" => :sierra
    sha256 "98165cdace91fda2dbc6d17639ad2dfcee8934e41581295637f1928a2d7b63b5" => :el_capitan
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
