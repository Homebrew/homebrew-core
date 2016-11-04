class Godep < Formula
  desc "Dependency tool for go"
  homepage "https://godoc.org/github.com/tools/godep"
  url "https://github.com/tools/godep/archive/v75.tar.gz"
  sha256 "a9508db6a792170f9815864b70a70a8e0e66ca0bf57f1a9cc087d811ec105494"
  head "https://github.com/tools/godep.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "467773cbeae5965315c97a7fb7dbe2a14a63cec89d182ec37d3a879ab540aa93" => :sierra
    sha256 "3ad1ff59294bc1c7470b4b4e9893ef3f588f1e18d4eb2a513ce74ac516b7a614" => :el_capitan
    sha256 "40c656af18ba770f68b5507761ab439bbf5a8a7c9449fdec5cb3a3586ebef1d1" => :yosemite
    sha256 "5d83bb27d58fff1a4c893a28b092235358f42bbe6eb12108d92c65a79e0f7d89" => :mavericks
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
