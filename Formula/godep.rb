class Godep < Formula
  desc "Dependency tool for go"
  homepage "https://godoc.org/github.com/tools/godep"
  url "https://github.com/tools/godep/archive/v79.tar.gz"
  sha256 "3dd2e6c4863077762498af98fa0c8dc5fedffbca6a5c0c4bb42b452c8268383d"
  revision 1
  head "https://github.com/tools/godep.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "f99f8f7c8c36a85e7dc16bbc7f731389ba8f62f58f3fdc9dd744c732f99441a6" => :sierra
    sha256 "1818f494ddb141154c2f453f839d4337883f0a2470c704e0f3b6a1770f80d3cc" => :el_capitan
    sha256 "03b48f1fdb71d4f9c311fbceb10d7a343bb944e6711b62b8dd83be804fc4b308" => :yosemite
  end

  depends_on "go"

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/tools/godep").install buildpath.children
    cd("src/github.com/tools/godep") { system "go", "build", "-o", bin/"godep" }
  end

  test do
    ENV["GOPATH"] = testpath.realpath
    (testpath/"Godeps/Godeps.json").write <<-EOS.undent
      {
        "ImportPath": "github.com/tools/godep",
        "GoVersion": "go1.8",
        "Deps": [
          {
            "ImportPath": "golang.org/x/tools/cover",
            "Rev": "3fe2afc9e626f32e91aff6eddb78b14743446865"
          }
        ]
      }
    EOS
    system bin/"godep", "restore"
    assert File.exist?("src/golang.org/x/tools/README"), "Failed to find 'src/golang.org/x/tools/README!' file"
  end
end
