class Godep < Formula
  desc "Dependency tool for go"
  homepage "https://godoc.org/github.com/tools/godep"
  url "https://github.com/tools/godep/archive/v70.tar.gz"
  sha256 "56f4947a89c48050318d4565ff454ac202cd3f2b5fd247fb4b7ed248917c2b17"
  head "https://github.com/tools/godep.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "949181fa7785032a48ed6f3667c26e4f843a8693b4d55da2a3395bf0ceefa49f" => :el_capitan
    sha256 "62d42d426ced4934de1d25034b48809117045e1e89a41483160abd7450841c7d" => :yosemite
    sha256 "d7127db15b6274c447a41e8ab7190b25441d8f3c36771b82b862bde7bf12ecea" => :mavericks
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
