class Godep < Formula
  desc "Dependency tool for go"
  homepage "https://godoc.org/github.com/tools/godep"
  url "https://github.com/tools/godep/archive/v79.tar.gz"
  sha256 "3dd2e6c4863077762498af98fa0c8dc5fedffbca6a5c0c4bb42b452c8268383d"
  revision 5

  head "https://github.com/tools/godep.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "23868f5c0587e16bcbd30e623daea1a661c234e2b65afaf29e5e802c4d1219b0" => :sierra
    sha256 "d829ac780f74e97a33adbf34c71bd0a6f559cd1dc3798aed1fdf387e48a94e64" => :el_capitan
    sha256 "78f3fbc0838cf96eab17bb7bcb7ae4f9c92f2f7d7bb3d98a8906c665d2e79bd6" => :yosemite
  end

  depends_on "go"

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/tools/godep").install buildpath.children
    cd buildpath/"src/github.com/tools/godep" do
      system "go", "build", "-o", bin/"godep"
      prefix.install_metafiles
    end
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
