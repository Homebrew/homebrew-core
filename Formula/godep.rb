class Godep < Formula
  desc "Dependency tool for go"
  homepage "https://godoc.org/github.com/tools/godep"
  url "https://github.com/tools/godep/archive/v80.tar.gz"
  sha256 "029adc1a0ce5c63cd40b56660664e73456648e5c031ba6c214ba1e1e9fc86cf6"
  revision 5
  head "https://github.com/tools/godep.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "fee50ea94c634192903fdd63be5bbe86ab1ef112dfa771d02da0db68c19abdda" => :high_sierra
    sha256 "39c001a3a6149e18be2a5a95a9087fff562b64ce270569343344e7e4c5743e06" => :sierra
    sha256 "a2346f03568ba0334759d0185ce4b04c6481df6c998abfde11779a88ab79c48c" => :el_capitan
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
