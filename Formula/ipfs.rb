class Ipfs < Formula
  desc "Peer-to-peer hypermedia protocol"
  homepage "https://ipfs.io/"
  url "https://github.com/ipfs/go-ipfs.git",
    :tag => "v0.4.2",
    :revision => "41c5e11ab1f99bd5aa2ba738fd7dd51392546863"
  head "https://github.com/ipfs/go-ipfs.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "b929c9af9e9dce5e73ef056f9c291193e640f6a14909bcac1e912d1daf6a1ba3" => :el_capitan
    sha256 "0396d6c7c0f99d82884bf8b87a14104e1e9fbbda11044648176c4242a3d06717" => :yosemite
    sha256 "2a0acfdd035b9328f4733303576348dd3554046f9edae660270e546f884717b4" => :mavericks
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
