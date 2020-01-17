class Frugal < Formula
  desc "Cross language code generator for creating scalable microservices"
  homepage "https://github.com/Workiva/frugal"
  url "https://github.com/Workiva/frugal/archive/3.7.0.tar.gz"
  sha256 "ad8e3b58b7b6444b64c07023fe2538162d8eb9b9d2b0f47acfaa252e80fabc3f"

  bottle do
    cellar :any_skip_relocation
    sha256 "6469b19ad93fcb1cde96ba8f3718562ba879a4bf435c2365a8b7b1cb08739636" => :catalina
    sha256 "adbd61619eea85ecb9c7629a895164599cc506b9e4038d6544063bca551e2299" => :mojave
    sha256 "3e8b4e589835cbcb8b488761e41afbf00ec91c1a6d6d111dbe77f3de77ad3608" => :high_sierra
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
