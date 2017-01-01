class Eris < Formula
  desc "Blockchain application platform CLI"
  homepage "https://erisindustries.com"
  url "https://github.com/eris-ltd/eris-cli/archive/v0.12.0.tar.gz"
  sha256 "54f00db6cd9b817dd7aa473194aa54ea1fdda7921ac4796f2bd7df4943beb2e1"
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

    (buildpath/"src/github.com/eris-ltd").mkpath
    ln_sf buildpath, buildpath/"src/github.com/eris-ltd/eris-cli"

    system "go", "build", "-o", "#{bin}/eris", "github.com/eris-ltd/eris-cli/cmd/eris"
  end

  test do
    system "#{bin}/eris", "version"
  end
end
