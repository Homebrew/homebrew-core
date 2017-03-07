class Ipfs < Formula
  desc "Peer-to-peer hypermedia protocol"
  homepage "https://ipfs.io/"
  url "https://github.com/ipfs/go-ipfs.git",
      :tag => "v0.4.6",
      :revision => "ed729423ce548785834cdcaa21aab11ebc3a1b1a"
  head "https://github.com/ipfs/go-ipfs.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "77c22864edac09c9feac71e13a1b712cdb707bf1f5a93a03c8b3267836ff75a6" => :sierra
    sha256 "26238cf78c5ff06914ef46b3836d9089261ca87e55636e4b50478bc7a76f6c2d" => :el_capitan
    sha256 "ab771d7fafdc31f01105b00c3fb4b4eada6e1db875d5680a1e510e54690aeb20" => :yosemite
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
