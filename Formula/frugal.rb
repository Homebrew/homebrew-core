class Frugal < Formula
  desc "Cross language code generator for creating scalable microservices"
  homepage "https://github.com/Workiva/frugal"
  url "https://github.com/Workiva/frugal/archive/v3.9.6.tar.gz"
  sha256 "579aa376d6e9f8c406a8f8ade0635d8eae807337a12c6189633225763e221cea"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "6e380e2ee5e23581867d98c86cf59cbec97b345a458d1db580b7c964721145c6" => :catalina
    sha256 "5610bad316949a4874474e4f634207f2033c9bb2a7ae95bf825a80b91bb97987" => :mojave
    sha256 "4a0bce17838c38a83a264f2decada3f673eb1f4ded42e9ebb782c70ea1780e09" => :high_sierra
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
