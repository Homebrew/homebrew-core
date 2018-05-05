class Annie < Formula
  desc "Fast, simple and clean video downloader"
  homepage "https://github.com/iawia002/annie"
  url "https://github.com/iawia002/annie/archive/0.6.10.tar.gz"
  sha256 "0653ea96a092621d3cf884269a0fc75fc767385e50acf9825fda1c4230b4b01b"

  bottle do
    cellar :any_skip_relocation
    sha256 "b86eb2b9315a94b0285163fdd00552fc787a54738f90b877f0310cb78a2e276e" => :high_sierra
    sha256 "a496e717bd8cbe8ee575b547d289c330b91bc6d5f213d89202e7f92ac410f747" => :sierra
    sha256 "8e83cb33d18dce86bc2a2e74eb104aaeda7f21d28c0d5abb0b389fc826db2e6b" => :el_capitan
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/iawia002/annie").install buildpath.children
    cd "src/github.com/iawia002/annie" do
      system "go", "build", "-o", bin/"annie"
      prefix.install_metafiles
    end
  end

  test do
    system bin/"annie", "-i", "https://www.bilibili.com/video/av20203945"
  end
end
