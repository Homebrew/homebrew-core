class Godep < Formula
  desc "Dependency tool for go"
  homepage "https://godoc.org/github.com/tools/godep"
  url "https://github.com/tools/godep/archive/v69.tar.gz"
  sha256 "a3eb2a2458383ffcd3d0df4565911aa601cd3172546749a571888ef3b11e9a0e"
  head "https://github.com/tools/godep.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "4d0c4d00c1f25f7786f324823379e68ebd86ec4cbf870c4127c0bfd2e236b1b5" => :el_capitan
    sha256 "a6d7a705c11263d7a62446a4c875c777f8f42a5d673e7be7d0c711ce9fd9cb48" => :yosemite
    sha256 "2fd334258c76b3d185c16fb8631cbafdc97fc028faa405b8767a6afacb0faa16" => :mavericks
  end

  depends_on "go"

  def install
    ENV["GOPATH"] = buildpath
    mkdir_p buildpath/"src/github.com/tools/"
    ln_sf buildpath, buildpath/"src/github.com/tools/godep"

    cd "src/github.com/tools/godep" do
      system "go", "build", "-o", bin/"godep"
    end
  end

  test do
    ENV["GO15VENDOREXPERIMENT"] = "0"
    mkdir "Godeps"
    (testpath/"Godeps/Godeps.json").write <<-EOS.undent
      {
        "ImportPath": "github.com/tools/godep",
        "GoVersion": "go1.6",
        "Deps": []
      }
    EOS
    system bin/"godep", "path"
  end
end
