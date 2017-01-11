class Godep < Formula
  desc "Dependency tool for go"
  homepage "https://godoc.org/github.com/tools/godep"
  url "https://github.com/tools/godep/archive/v76.tar.gz"
  sha256 "f52ddbb3c784decfefb60436efb96adf525cc4c7d080ab7953a2eb1dddc65a83"
  head "https://github.com/tools/godep.git"

  bottle do
    sha256 "61d05bbdfdcdc17dabe4c102d8d4110f29d6c6b4285e36eff984b4d40d25b39a" => :sierra
    sha256 "6b7ad2c887047447779635ef8e6e487c4ec0a723a786017ad2924300e5c02087" => :el_capitan
    sha256 "bf6e687ee642e85561649b369ec1d776da723f2097df2648bc3b0e43bdde4072" => :yosemite
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
        "GoVersion": "go1.7",
        "Deps": [
          {
            "ImportPath": "go.googlesource.com/tools",
            "Rev": "3fe2afc9e626f32e91aff6eddb78b14743446865"
          }
        ]
      }
    EOS
    system bin/"godep", "restore"
    assert File.exist?("src/go.googlesource.com/tools/README")
  end
end
