class Godep < Formula
  desc "Dependency tool for go"
  homepage "https://godoc.org/github.com/tools/godep"
  url "https://github.com/tools/godep/archive/v79.tar.gz"
  sha256 "3dd2e6c4863077762498af98fa0c8dc5fedffbca6a5c0c4bb42b452c8268383d"
  revision 2

  head "https://github.com/tools/godep.git"

  bottle do
    sha256 "2787471d1831ac8980437b0818180291bf5dbdb552cc55a0887c9cec19ae77ff" => :sierra
    sha256 "f24fd0974edb179c3e6ae5c87c006d36b9b329866d41f130447d129e9994d1fe" => :el_capitan
    sha256 "6f5d428791e587fb4d936404b159ef77f1e97d8537f76c55dd41d095e3160f26" => :yosemite
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
        "GoVersion": "go1.8",
        "Deps": [
          {
            "ImportPath": "golang.org/x/tools/cover",
            "Rev": "3fe2afc9e626f32e91aff6eddb78b14743446865"
          }
        ]
      }
    EOS
    system bin/"godep", "restore"
    assert_predicate testpath/"src/golang.org/x/tools/README", :exist?,
                     "Failed to find 'src/golang.org/x/tools/README!' file"
  end
end
