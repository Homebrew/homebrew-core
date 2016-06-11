class Eris < Formula
  desc "Blockchain application platform CLI"
  homepage "https://erisindustries.com"
  url "https://github.com/eris-ltd/eris-cli/archive/v0.11.4.tar.gz"
  sha256 "e2eb02d01b76e8be9f28aac31b2e56ebadc4d0decb21fcfefb2f219cb03d1238"

  bottle do
    cellar :any_skip_relocation
    sha256 "f79939887e0337eab955c03d3abc4dc8003b02f780a600eefa4311f8da0eb354" => :el_capitan
    sha256 "9e80b2b77b45fd997f07b6a622d48b6686e49421f75333b2a2eb878710b55c88" => :yosemite
    sha256 "b859c6d4f18bc2310f9aa97be6b98b5a5e3d620eb7d9e3d386283ed70cbab665" => :mavericks
  end

  depends_on "go" => :build
  depends_on "docker"
  depends_on "docker-machine"

  def install
    ENV["GOPATH"] = buildpath

    (buildpath/"src/github.com/eris-ltd").mkpath
    ln_sf buildpath, buildpath/"src/github.com/eris-ltd/eris-cli"

    system "go", "build", "-o", "#{bin}/eris", "github.com/eris-ltd/eris-cli/cmd/eris"
  end

  test do
    system "#{bin}/eris", "--version"
  end
end
