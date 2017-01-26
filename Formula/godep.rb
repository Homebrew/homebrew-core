class Godep < Formula
  desc "Dependency tool for go"
  homepage "https://godoc.org/github.com/tools/godep"
  url "https://github.com/tools/godep/archive/v78.tar.gz"
  sha256 "247cbebffff1a5e077287cc7e2f84ca30266f9e535d1182823ececf9bf37b18a"
  revision 1
  head "https://github.com/tools/godep.git"

  bottle do
    sha256 "e35d1482f7faaf7596399722e24c76aab257da08ff2c4831473d643941461ef9" => :sierra
    sha256 "6ffc281d817db545aed8affe48d720bb7d816e424668d36f891d1131f617befa" => :el_capitan
    sha256 "d18c5626444a94e5633b748f430f62567221be886e87924d726aaf8d9fe90931" => :yosemite
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
