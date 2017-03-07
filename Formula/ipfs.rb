class Ipfs < Formula
  desc "Peer-to-peer hypermedia protocol"
  homepage "https://ipfs.io/"
  url "https://github.com/ipfs/go-ipfs.git",
      :tag => "v0.4.6",
      :revision => "ed729423ce548785834cdcaa21aab11ebc3a1b1a"
  head "https://github.com/ipfs/go-ipfs.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "f6eeab37b4054a1c4a20182b1d8779be436ab57c0e8ab213373cd0728e9384f8" => :sierra
    sha256 "72bbaa7d093ee906b7fd989f21fc5c7f583d50d6112f03d6e059042ba78eba17" => :el_capitan
    sha256 "9c8c0923a7a823b121a29abf9033f64f6c2baf73d6cf54f8b6509cfa3ddf8427" => :yosemite
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
