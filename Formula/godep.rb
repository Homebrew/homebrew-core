class Godep < Formula
  desc "Dependency tool for go"
  homepage "https://godoc.org/github.com/tools/godep"
  url "https://github.com/tools/godep/archive/v75.tar.gz"
  sha256 "a9508db6a792170f9815864b70a70a8e0e66ca0bf57f1a9cc087d811ec105494"
  head "https://github.com/tools/godep.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "241da4d518b01883be656c1d08891371b5f419e46cc515a4b1c564ec7e46fb01" => :sierra
    sha256 "d9c70e8befc0ab8749bb99631d3baa93589fa4d1be26d4f63efd4151ea4c5e05" => :el_capitan
    sha256 "6a947f4380a8f85ee1420023043e26fb4e5a97ebb9922242df960efd45a50713" => :yosemite
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
