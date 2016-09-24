class Ipfs < Formula
  desc "Peer-to-peer hypermedia protocol"
  homepage "https://ipfs.io/"
  url "https://github.com/ipfs/go-ipfs.git",
      :tag => "v0.4.3",
      :revision => "189fa76bce0355bb9b84033aaead5768e2334ee6"
  head "https://github.com/ipfs/go-ipfs.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "750a80d616e46581d2c311f98286edaf4edb45f5d68d9814aa82d2c9a6b8e3c8" => :sierra
    sha256 "f57865fbc7bd2af4cae5583d25e918a08c98b05d6660e3c070b90aebca25de19" => :el_capitan
    sha256 "d49fc0770cd32ddd9f0ab50d34663134cec30c027cdc1b8312c78c61e344bcb8" => :yosemite
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
