class Frugal < Formula
  desc "Cross language code generator for creating scalable microservices"
  homepage "https://github.com/Workiva/frugal"
  url "https://github.com/Workiva/frugal/archive/v3.4.9.tar.gz"
  sha256 "a363070071b9f884f7dd192065f829d66dee8fb6ae0c72e1f25e06eadabb8df9"

  bottle do
    cellar :any_skip_relocation
    sha256 "21d680581893434ef6b2f90d29c33ddffd267b2089f7cffada3e70a5ccc32891" => :catalina
    sha256 "63fe2b5e16730202ce5232d6ce134582cce0a942081c43c1238b315d761cb9a0" => :mojave
    sha256 "0a2ff09371167086263d39543054b0bdd68e495a3c37e4f666a6d6260a72b484" => :high_sierra
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
