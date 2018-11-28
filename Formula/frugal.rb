class Frugal < Formula
  desc "Cross language code generator for creating scalable microservices"
  homepage "https://github.com/Workiva/frugal"
  url "https://github.com/Workiva/frugal/archive/2.24.0.tar.gz"
  sha256 "bc236864b044b333c5398a44a39cee080494f85370815aa3dbc3c86400d90e58"

  bottle do
    cellar :any_skip_relocation
    sha256 "439987efb791573b74f6960f637af6417bbd1ced260261418b962e39c209a9b6" => :mojave
    sha256 "54a288c5a38a7a5f7d0be49afdc03fd874aad971550b3b32a0e14535691bba05" => :high_sierra
    sha256 "bc87dab34f06ddc5b33ddf34b05b59fdad2bc58292615090954cc5a84d5bb953" => :sierra
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
