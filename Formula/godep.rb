class Godep < Formula
  desc "Dependency tool for go"
  homepage "https://godoc.org/github.com/tools/godep"
  url "https://github.com/tools/godep/archive/v65.tar.gz"
  sha256 "9171e5389c1837aded59bba8c15785dc2fdbcfb76e18e0efe54f37002a561a0b"
  head "https://github.com/tools/godep.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "029116dc904db10e291cbe8432203913087f97856db793571972fa38df8dd489" => :el_capitan
    sha256 "cfdbc86b33a056aff994098f10d419d9649b473b5f078f0dd5dddbbd5200bbc8" => :yosemite
    sha256 "d54094f87003fcc15b5ae3d202603241914d261ee41fdbc92dc84716d92f5479" => :mavericks
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
