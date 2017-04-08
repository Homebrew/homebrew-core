class Monax < Formula
  desc "Blockchain application platform CLI"
  homepage "https://erisindustries.com"
  url "https://github.com/monax/cli/archive/v0.16.0.tar.gz"
  sha256 "b5a1b52e07de585903e7f505fd16ef7dddf4ab43d850aee909f9cf8aa902d197"
  version_scheme 1

  bottle do
    cellar :any_skip_relocation
    sha256 "9542a6efef2e45633ca7607f4d4b70362a98ddb8ef7038a830a45c1da623caf6" => :sierra
    sha256 "ae31e13e58224e20c669a49bb9939aa00f5fd3dbf245449e077cefdff16fd00e" => :el_capitan
    sha256 "da8d00b5d246007abcb16715da89ed5cb46eb6742cb553dc35e23f8ee053c949" => :yosemite
  end

  depends_on "go" => :build
  depends_on "docker"
  depends_on "docker-machine"

  def install
    ENV["GOPATH"] = buildpath
    ENV["GOBIN"] = bin
    (buildpath/"src/github.com/monax").mkpath
    ln_sf buildpath, buildpath/"src/github.com/monax/cli"
    system "go", "install", "github.com/monax/cli/cmd/monax"
  end

  test do
    system "#{bin}/monax", "version"
  end
end
