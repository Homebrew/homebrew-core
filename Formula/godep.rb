class Godep < Formula
  desc "Dependency tool for go"
  homepage "https://godoc.org/github.com/tools/godep"
  url "https://github.com/tools/godep/archive/v74.tar.gz"
  sha256 "e68c7766c06c59327a4189fb929d390e1cc7a0c4910e33cada54cf40f40ca546"
  revision 1

  head "https://github.com/tools/godep.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "579f045a461652d9e68ef98919665f0e2a2f36186bcc46729eb1ce5364f0750a" => :el_capitan
    sha256 "0b771abd160189b631719ea25e6b7e2eb8b064571292354b29d38feba09242c7" => :yosemite
    sha256 "cdbf4b630a90d8cc4d36076a963916fc979311b2acc413865512b78a41c3aed4" => :mavericks
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
