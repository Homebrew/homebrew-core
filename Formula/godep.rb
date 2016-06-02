class Godep < Formula
  desc "Dependency tool for go"
  homepage "https://godoc.org/github.com/tools/godep"
  url "https://github.com/tools/godep/archive/v74.tar.gz"
  sha256 "e68c7766c06c59327a4189fb929d390e1cc7a0c4910e33cada54cf40f40ca546"
  head "https://github.com/tools/godep.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "0ccc6c361a821dd7c91c1f2c34a19c6ed8ff75e211a686a8ff48e742bee6f73d" => :el_capitan
    sha256 "c4b4192885ee42380a4b73931d23688ce8b3cd0959e9051c1fa1e7ef660fa978" => :yosemite
    sha256 "37ce5e96360c1facb8a9900e4280f84f7bba4411de7365831dafa860c55df9ea" => :mavericks
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
