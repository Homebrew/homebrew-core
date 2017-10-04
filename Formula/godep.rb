class Godep < Formula
  desc "Dependency tool for go"
  homepage "https://godoc.org/github.com/tools/godep"
  url "https://github.com/tools/godep/archive/v79.tar.gz"
  sha256 "3dd2e6c4863077762498af98fa0c8dc5fedffbca6a5c0c4bb42b452c8268383d"
  revision 7

  head "https://github.com/tools/godep.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "5ae0a36c8dfe8b1d97a409e17cc6d7af915d994ad2c2fe9707099594f2c70c7c" => :high_sierra
    sha256 "56c8abce2d2b0bef305ba34c0ab29da45bbd22dff342ad8f917af4f5b2a6979d" => :sierra
    sha256 "5e9e6881d9a681fd5ff4093f530ef0c12e19cd3d012fe15113cadf2d7fb7e38e" => :el_capitan
    sha256 "7183e326952679eaf0344059b3de3ecfe8e0c0aec1697f419e40e306bbb0ca21" => :yosemite
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
