class Deisctl < Formula
  desc "Deis Control Utility"
  homepage "http://deis.io/"
  url "https://github.com/deis/deis/archive/v1.13.3.tar.gz"
  sha256 "a5b28a7b94e430c4dc3cf3f39459b7c99fc0b80569e14e3defa2194d046316fd"

  bottle do
    cellar :any_skip_relocation
    sha256 "dc7a728554046e2f6191ca4d0d2b61ecbd7c3c6b1e5f929b2f6f71a53c94a458" => :sierra
    sha256 "1c3ce561d7b81441c162084775d5d295919550534520ec475216ca6c9af96b56" => :el_capitan
    sha256 "3450f08fb4a5e46768c81ac57742b5b234a1171c93c195004627445c03f8ddbf" => :yosemite
    sha256 "7ce46bd2b45d6772625ff82f4076ec42cb0232e4f896b07bda108c5f2db59f2e" => :mavericks
  end

  depends_on "go" => :build
  depends_on "godep" => :build

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/deis").mkpath
    ln_s buildpath, "src/github.com/deis/deis"
    system "godep", "restore"
    system "go", "build", "-o", bin/"deisctl", "deisctl/deisctl.go"
  end

  test do
    system bin/"deisctl", "help"
  end
end
