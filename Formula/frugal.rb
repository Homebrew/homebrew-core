class Frugal < Formula
  desc "Cross language code generator for creating scalable microservices"
  homepage "https://github.com/Workiva/frugal"
  url "https://github.com/Workiva/frugal/archive/2.8.1.tar.gz"
  sha256 "7bcbecee6cc908ed58f3dc7963b101eda43cbe9ab139d655d8c4e0dd670f06ce"

  bottle do
    cellar :any_skip_relocation
    sha256 "f39031feed4f4adec78a4738577849334ba2b0e453af10ad0c96957067b2395d" => :sierra
    sha256 "7a055e7ef739beb3eb35a391bf05ca6f32b0f7c5be7dc456a5c12f528631ebad" => :el_capitan
    sha256 "1b8471c060e8b46f7302b01e0e1b882042a48296783640086fc5dd472e33c9c2" => :yosemite
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
