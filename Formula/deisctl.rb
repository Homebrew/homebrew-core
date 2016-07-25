class Deisctl < Formula
  desc "Deis Control Utility"
  homepage "http://deis.io/"
  url "https://github.com/deis/deis/archive/v1.13.2.tar.gz"
  sha256 "3e583cc0af91fa617b1b732acd38beb8c094cfcd511af19ebac949533c981e2b"

  bottle do
    cellar :any_skip_relocation
    sha256 "08d1e5bad11d8ab1555bef30e7bfdf0437b493f3e18dd1dd48934d48172f428b" => :el_capitan
    sha256 "a7c22bf596d3167c0a74abe1bb0d84dcfb9eadd986d6b6c73241d1a18fd2666b" => :yosemite
    sha256 "0feba5e74ba401b1d8d39d623f716924dad54614a3cb00fe55faaac651866af5" => :mavericks
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
