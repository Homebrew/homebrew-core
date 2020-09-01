class Godep < Formula
  desc "Dependency tool for go"
  homepage "https://godoc.org/github.com/tools/godep"
  url "https://github.com/tools/godep/archive/v80.tar.gz"
  sha256 "029adc1a0ce5c63cd40b56660664e73456648e5c031ba6c214ba1e1e9fc86cf6"
  license "BSD-3-Clause"
  revision 39
  head "https://github.com/tools/godep.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "141260f7b4c5e0dbd5c2c7b4ec513ae1e5f8d5ab20661a0c872c95f6d5f459fe" => :catalina
    sha256 "b07e664a25d5384e11c9f4623de7bb2b3921cb99485a66f86f1f711fa9d49624" => :mojave
    sha256 "86892d7dd9770920ee08c761a722f85a9354f9813e0119e8fc2f67e8fff0b79b" => :high_sierra
  end

  deprecate! date: "2018-01-26", because: :repo_archived

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
