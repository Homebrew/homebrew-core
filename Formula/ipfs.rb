class Ipfs < Formula
  desc "Peer-to-peer hypermedia protocol"
  homepage "https://ipfs.io/"
  url "https://github.com/ipfs/go-ipfs.git",
    :tag => "v0.4.2",
    :revision => "41c5e11ab1f99bd5aa2ba738fd7dd51392546863"
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
    (buildpath/"src/github.com/ipfs/go-ipfs").install buildpath.children
    cd("src/github.com/ipfs/go-ipfs") { system "make", "install" }
    bin.install "bin/ipfs"
  end

  test do
    system bin/"ipfs", "version"
  end
end
