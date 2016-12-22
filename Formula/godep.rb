class Godep < Formula
  desc "Dependency tool for go"
  homepage "https://godoc.org/github.com/tools/godep"
  url "https://github.com/tools/godep/archive/v75.tar.gz"
  sha256 "a9508db6a792170f9815864b70a70a8e0e66ca0bf57f1a9cc087d811ec105494"
  revision 1

  head "https://github.com/tools/godep.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "d8c2799e55c8e151076e91b7d85e6254ca28162bfda5f28cc720942871ac0a56" => :sierra
    sha256 "1d99f571168cd3681d01dd985dfb02c6d4abef0d7a42a4d7010e8bb7911c830c" => :el_capitan
    sha256 "ec6fbde1230bdafb10a0ce249b61a110c1ef92c04a78f13c57621c3ab896688d" => :yosemite
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
