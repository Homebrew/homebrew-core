class Frugal < Formula
  desc "Cross language code generator for creating scalable microservices"
  homepage "https://github.com/Workiva/frugal"
  url "https://github.com/Workiva/frugal/archive/v3.12.0.tar.gz"
  sha256 "ca4e1267adfc08ad024e4a3b9ee8dfc7401abbc3b87ec6afef405efd5f512fa0"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "d674c6275d4dcd8f7c2c73ded930e3fc7819a88ff3b1f0006881e07a8f1fb50d" => :catalina
    sha256 "48370c82e9e201210f22f7b6bdbbabe7724b61eef8bbf5128ed7b555ecae0268" => :mojave
    sha256 "9f016a8fc19c8f634410a0b6a23a78abff138560b806576cb3770a7272173273" => :high_sierra
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
