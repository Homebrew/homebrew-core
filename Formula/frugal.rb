class Frugal < Formula
  desc "Cross language code generator for creating scalable microservices"
  homepage "https://github.com/Workiva/frugal"
  url "https://github.com/Workiva/frugal/archive/v3.7.1.tar.gz"
  sha256 "b3677707ce08caf337ac9965df2f6af3cefd5d94df28f666687c9cc90779524a"

  bottle do
    cellar :any_skip_relocation
    sha256 "e3f050449545fd988e562b8299a8798c01899feea8b1e5cbc3e42c4fcb9306a8" => :catalina
    sha256 "abf5c9c30888f09d93b36680478d9fb4fdd3c4ee7c89f76216231da7a71ef797" => :mojave
    sha256 "7535fbd70e6c54c43d5d5d8a0f9e5c94ffd3d72ec74070d070a193edb397b989" => :high_sierra
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
