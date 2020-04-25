class Frugal < Formula
  desc "Cross language code generator for creating scalable microservices"
  homepage "https://github.com/Workiva/frugal"
  url "https://github.com/Workiva/frugal/archive/v3.9.4.tar.gz"
  sha256 "a8c407c2df54e0aecc4e46aa2ad0229707f5edc8cb1c97d2a8217ccd11718d2f"

  bottle do
    cellar :any_skip_relocation
    sha256 "6b1016224878e67ce0aebcfed4c04f0bc67916e9fefa6fc12e93e80cd041659a" => :catalina
    sha256 "8c351fe40f24d804ff66afc03e1520b9f406374c34566730d5d0081a1d73d990" => :mojave
    sha256 "d51a06c8ae7e278e9f4ac9acf0aa8b43357933db512a906560389b5058bb24fe" => :high_sierra
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
