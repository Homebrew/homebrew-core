class Godep < Formula
  desc "Dependency tool for go"
  homepage "https://godoc.org/github.com/tools/godep"
  url "https://github.com/tools/godep/archive/v78.tar.gz"
  sha256 "247cbebffff1a5e077287cc7e2f84ca30266f9e535d1182823ececf9bf37b18a"
  revision 1
  head "https://github.com/tools/godep.git"

  bottle do
    sha256 "1b111f2663dc031b407b3e8f917b853a6dca16b36b1edf9e6c69d78abecb7e09" => :sierra
    sha256 "069578a238f23a2685ef03f97051eaaa540f42a9e48755eaecb5e280a2333fac" => :el_capitan
    sha256 "10e423c520c7f00d58f93f7a414f7dd847b1b5021a4df1f24d2f385a691caa29" => :yosemite
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
