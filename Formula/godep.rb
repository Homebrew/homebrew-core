class Godep < Formula
  desc "Dependency tool for go"
  homepage "https://godoc.org/github.com/tools/godep"
  url "https://github.com/tools/godep/archive/v75.tar.gz"
  sha256 "a9508db6a792170f9815864b70a70a8e0e66ca0bf57f1a9cc087d811ec105494"
  revision 3
  head "https://github.com/tools/godep.git"

  bottle do
    sha256 "b9c34eb3bc69fc2d23a266140996857fd7dc2f006069b4211a7937f4ef7de14b" => :sierra
    sha256 "1d3fc2732d7619676df9045d3724170187f12ea85c946f2bf06dfacd80730dcf" => :el_capitan
    sha256 "fa609d65f0bd90fe4f2e409ae1ac254d3a0efb57d80665205dfee314c4d5a962" => :yosemite
  end

  depends_on "go"

  # Add support for Go 1.8+, currently devel.
  patch do
    url "https://github.com/tools/godep/pull/524.patch"
    sha256 "245ff4b4fad3831fd2a2a51ba4ac7b01e3affad1a25a7b4da8ef31e7a387c7b8"
  end

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
