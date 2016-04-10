require "language/go"

class Ipfs < Formula
  desc "IPFS is The Permanent Web - A new peer-to-peer hypermedia protocol"
  homepage "https://ipfs.io/"
  url "https://github.com/ipfs/go-ipfs.git",
    :tag => "v0.4.0",
    :revision => "600c95eb53e576530d73afe856bf11ae219b3acb"
  head "https://github.com/ipfs/go-ipfs.git"

  bottle do
    cellar :any_skip_relocation
    revision 1
    sha256 "6744fb99a312598513e260adbd3b5895db82c0f0b6f447a58b0cc9084bf4b5cc" => :el_capitan
    sha256 "3b641f107ec102859819afcea8ed5b8265e7b295fba1913af6b1b55593d5956e" => :yosemite
    sha256 "dd9de372d81abb5e624b320fa4fb00f175c991bf3b6705b12423973b4cafaa97" => :mavericks
  end

  depends_on "go" => :build
  depends_on "godep" => :build
  depends_on "gx"
  depends_on "gx-go"

  def install
    ENV["GOPATH"] = buildpath
    ENV["GO15VENDOREXPERIMENT"] = "0"
    mkdir_p buildpath/"src/github.com/ipfs/"
    ln_sf buildpath, buildpath/"src/github.com/ipfs/go-ipfs"
    Language::Go.stage_deps resources, buildpath/"src"

    cd "cmd/ipfs" do
      system "make", "build"
      bin.install "ipfs"
    end
  end

  test do
    system "#{bin}/ipfs", "version"
  end
end
