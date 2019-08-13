class Godep < Formula
  desc "Dependency tool for go"
  homepage "https://godoc.org/github.com/tools/godep"
  url "https://github.com/tools/godep/archive/v80.tar.gz"
  sha256 "029adc1a0ce5c63cd40b56660664e73456648e5c031ba6c214ba1e1e9fc86cf6"
  revision 20
  head "https://github.com/tools/godep.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "d2cca1226865f0cc490a2d753867607decfe5b1a0e1d3cc9bb181196011e8187" => :mojave
    sha256 "45ba8469add2ecd775189c72548b20dc14fe6e69f6e71477002bdea702e86ea1" => :high_sierra
    sha256 "7c7afd5f5e1a69146fee7ffb53b75290cd28b956c1b5dc2fbd1df2e0994fd2cb" => :sierra
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
