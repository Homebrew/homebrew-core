class Deisctl < Formula
  desc "Deis Control Utility"
  homepage "http://deis.io/"
  url "https://github.com/deis/deis/archive/v1.13.2.tar.gz"
  sha256 "3e583cc0af91fa617b1b732acd38beb8c094cfcd511af19ebac949533c981e2b"

  bottle do
    cellar :any_skip_relocation
    sha256 "ae17d6bda26e9c497c1424d098538ac96c821ccd39966a7d391155b1311f5240" => :el_capitan
    sha256 "2ca0059e5a3a156ceefcf2191940368c8fcf47b884ac9c12f570545d2c37e022" => :yosemite
    sha256 "71c7e4237c0163eae73d0bca9caa722fe8abe980b95d0e5e9ca8d5f46f492a81" => :mavericks
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
