class Godep < Formula
  desc "Dependency tool for go"
  homepage "https://godoc.org/github.com/tools/godep"
  url "https://github.com/tools/godep/archive/v73.tar.gz"
  sha256 "c2a2b37c20620d19cf341c479442067434049171e9cc3e226cdddde34aa6b3d9"
  head "https://github.com/tools/godep.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "4d752f58d29f364f64653a82b26841c9f1344659cdbe3ea2510ca0696f99f903" => :el_capitan
    sha256 "8becfb86eb3e7ac7dc9761a67d994b423337255b2e5b9c5d2029f77c25f7155f" => :yosemite
    sha256 "03ac51a592c847f7bd247847756c5a980cfacc26b8ff10cb9810dc6215d03e71" => :mavericks
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
