class Godep < Formula
  desc "Dependency tool for go"
  homepage "https://godoc.org/github.com/tools/godep"
  url "https://github.com/tools/godep/archive/v79.tar.gz"
  sha256 "3dd2e6c4863077762498af98fa0c8dc5fedffbca6a5c0c4bb42b452c8268383d"
  revision 9

  head "https://github.com/tools/godep.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "8474e119f68b3ab8a95f2c0d03e2ddd7094c469c2a9e17d296989e3e4496d3e5" => :high_sierra
    sha256 "5a04895ea72195178eec1863e4c3e6337b521fbd38b81e4f56d22cac0520c075" => :sierra
    sha256 "6dbdf63ac949d54632fd6144d685dc22d2135a49fb74e8e30e8a51192cdbe5d0" => :el_capitan
  end

  depends_on "go"

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/tools/godep").install buildpath.children
    cd buildpath/"src/github.com/tools/godep" do
      system "go", "build", "-o", bin/"godep"
      prefix.install_metafiles
    end
  end

  test do
    ENV["GOPATH"] = testpath.realpath
    (testpath/"Godeps/Godeps.json").write <<~EOS
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
    assert_predicate testpath/"src/golang.org/x/tools/README", :exist?,
                     "Failed to find 'src/golang.org/x/tools/README!' file"
  end
end
