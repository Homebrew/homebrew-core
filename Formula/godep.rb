class Godep < Formula
  desc "Dependency tool for go"
  homepage "https://godoc.org/github.com/tools/godep"
  url "https://github.com/tools/godep/archive/v74.tar.gz"
  sha256 "e68c7766c06c59327a4189fb929d390e1cc7a0c4910e33cada54cf40f40ca546"
  head "https://github.com/tools/godep.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "d53d5f3fb6d68b4ce6d8369ca3ae98d6158eb0e446b2c947054e64148af4a615" => :el_capitan
    sha256 "60e4acafeec05862d96db271bc88125891da60e9df7b33d5e0fad9545cb45fe3" => :yosemite
    sha256 "47bd9256dd31761cc232ad67d5857381795bfc545c39552853d9d8270ee824b3" => :mavericks
  end

  depends_on "go"

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/tools/godep").install buildpath.children
    cd("src/github.com/tools/godep") { system "go", "build", "-o", bin/"godep" }
  end

  test do
    ENV["GO15VENDOREXPERIMENT"] = "0"
    ENV["GOPATH"] = testpath.realpath
    (testpath/"Godeps.json").write <<-EOS.undent
      {
        "ImportPath": "github.com/tools/godep",
        "GoVersion": "go1.6",
        "Deps": []
      }
    EOS
    (testpath/"src/foo/bar/Godeps").install "Godeps.json"
    cd("src/foo/bar") { system bin/"godep", "path" }
  end
end
