class Monax < Formula
  desc "Blockchain application platform CLI"
  homepage "https://erisindustries.com"
  url "https://github.com/monax/cli/archive/v0.17.0.tar.gz"
  sha256 "c13d163a39c79e1c651d2ff7072c3c9e4e88fb38dc5f92bcc87acb3f54ad01ee"
  version_scheme 1

  bottle do
    cellar :any_skip_relocation
    sha256 "b3da0e1c7b6cbcf3a0d973292c0c3751fa1d5254341845af92ec9a8c61f0b58b" => :sierra
    sha256 "15da3977ae30866f6fc5e6e287887c9304b8860999ec84a3a12b655d3f51a7db" => :el_capitan
    sha256 "a7e282a0ec7ec7852abd17f8cfdfced983e8285aa697accf2e1bb07e5edb42cb" => :yosemite
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
