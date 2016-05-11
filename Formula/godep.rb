class Godep < Formula
  desc "Dependency tool for go"
  homepage "https://godoc.org/github.com/tools/godep"
  url "https://github.com/tools/godep/archive/v66.tar.gz"
  sha256 "730020ef823dc29cdc139c097831a4df7a7b91941e378efd37f9e217dae62eb5"
  head "https://github.com/tools/godep.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "a8e3f8162ef63345fd5c8055b2281a80407495776aa5efa50035eb792ab75369" => :el_capitan
    sha256 "2c8fb0ed562bf62193b106a6f96541414ee768e0d445af1cedb58a082abbb235" => :yosemite
    sha256 "e0c6b5e5ddf5b943ad52d30107d70cfc0a28019cae3f2507496db32e896b1f38" => :mavericks
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
    (testpath/"Godeps/Geodeps.json").write <<-EOS.undent
      {
        "ImportPath": "github.com/tools/godep",
        "GoVersion": "go1.4.2",
        "Deps": []
      }
    EOS
    system bin/"godep", "path"
  end
end
