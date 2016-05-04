class Godep < Formula
  desc "Dependency tool for go"
  homepage "https://godoc.org/github.com/tools/godep"
  url "https://github.com/tools/godep/archive/v63.tar.gz"
  sha256 "2d7407664d24b91e0416d2d9c54521a9a829244fd15cfd453e7d15349cf9b6af"
  head "https://github.com/tools/godep.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "13a6f3482e2cacd7a1629ef5916f48a632ac00152ea01eb280a89c43ffbe7af0" => :el_capitan
    sha256 "c084bb3eaeec2725411f205110544a7fe4969cfa0ac1bdca56bb1ae073f44666" => :yosemite
    sha256 "980076d03de824833c8614b58ad3d8187046883a4b189195478745ebf5d6254d" => :mavericks
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
