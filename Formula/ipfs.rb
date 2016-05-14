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
    sha256 "d05b228ef094967bf153728c4047c1dd43e8f4ba8b199f167da34d82c6078558" => :el_capitan
    sha256 "1265f249cc18846bb3fc87560672b8311913708b86c1889c7b05e4e770bdf40e" => :yosemite
    sha256 "6f01e478049865c814dc351ec127c3213ba4f7503d86f0973ee39595386f2659" => :mavericks
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
