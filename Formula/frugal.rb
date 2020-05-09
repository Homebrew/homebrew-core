class Frugal < Formula
  desc "Cross language code generator for creating scalable microservices"
  homepage "https://github.com/Workiva/frugal"
  url "https://github.com/Workiva/frugal/archive/v3.9.5.tar.gz"
  sha256 "8c1be4f2a2a673e8d94be13635b95412977f6eebac62596b4fd9fdac35cf5d1c"

  bottle do
    cellar :any_skip_relocation
    sha256 "37820d40990c674bbced33a21aaa015c4a12a0c2db2bd2c6f2ec435651258b85" => :catalina
    sha256 "ea0e47bf0578925e7ca2a063847faa2d4d95c0ccc59e521fde3dab784d13955a" => :mojave
    sha256 "91e0e3caece64377ea001b3d97ee415e85c64786e162d36c9234d31aa784ad15" => :high_sierra
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
