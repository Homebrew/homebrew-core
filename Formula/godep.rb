class Godep < Formula
  desc "Dependency tool for go"
  homepage "https://godoc.org/github.com/tools/godep"
  url "https://github.com/tools/godep/archive/v80.tar.gz"
  sha256 "029adc1a0ce5c63cd40b56660664e73456648e5c031ba6c214ba1e1e9fc86cf6"
  revision 23
  head "https://github.com/tools/godep.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "1556c629a4b095c1c3b15328466ef29c27ef8e50e51392dffd26e6683c86d801" => :catalina
    sha256 "e79b5e4c8eeae5cfaa05ad63df5500a058ea47eca96a711565d1d09912c1c656" => :mojave
    sha256 "2546c2aa3fc06f6af68cfd7925b533b21d2e824309460c5fb2cbe25b86c3559f" => :high_sierra
  end

  depends_on "go"

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/tools/godep").install buildpath.children
    cd "src/github.com/tools/godep" do
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
