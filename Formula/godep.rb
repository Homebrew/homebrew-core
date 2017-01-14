class Godep < Formula
  desc "Dependency tool for go"
  homepage "https://godoc.org/github.com/tools/godep"
  url "https://github.com/tools/godep/archive/v77.tar.gz"
  sha256 "aa86d1fbb7f6faa4e986c306021c3ebe3fe649def53acf926c6783d51637f4be"
  head "https://github.com/tools/godep.git"

  bottle do
    sha256 "44b706f9c9d6fef67af618a06cfeb90c7ee054dcad81778fb0025942fcdafd19" => :sierra
    sha256 "898301135253482b871c22c98bb8e6b6f544b7e7d96c14ad2c5515522b88e85d" => :el_capitan
    sha256 "72b0ff2b9200843edd9251d1588d6e518d5c5f92143b86b3f9eaaf3663ffbb1e" => :yosemite
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
