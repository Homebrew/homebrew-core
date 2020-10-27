class Frugal < Formula
  desc "Cross language code generator for creating scalable microservices"
  homepage "https://github.com/Workiva/frugal"
  url "https://github.com/Workiva/frugal/archive/v3.12.1.tar.gz"
  sha256 "e01c8d643096e8ec0ceb22852e4065312b32aa3c0fe84808474c3583594646fa"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "c845b9c6362982511fb2ef5fc845e604aed74a743a45a56ae8b13507da003b69" => :catalina
    sha256 "e40ff743a3a9683c8091a58f7d0d2000cc07f0fbfe8e3435c73d28aadee9b193" => :mojave
    sha256 "3db23dd902f7abfc932ca302d3ecdfc456f39cca2080830b84781451d28cd078" => :high_sierra
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
