class Hyper < Formula
  desc "Client for HyperHQ's cloud service"
  homepage "https://hyper.sh"
  url "https://github.com/hyperhq/hypercli.git",
      :tag => "v1.10.15",
      :revision => "c9c8ca50eee61ba47a9eb3d195ae0d87566a4bd2"

  head "https://github.com/hyperhq/hypercli.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "622a203e0eca9e0119db6873db9ef3639c668abbdaf9fc9cae2d04965b4565df" => :high_sierra
    sha256 "eb1589822317964a0d767f408bb6ad8352e5a95ff247e63b5f68c5feee144444" => :sierra
    sha256 "29d4616bce077339982b742013a470f69e63da316cd845c90cd9114d295360f5" => :el_capitan
    sha256 "45bfd893e2bfbbd07b97d000802e500d0fbe90df77d60332fdf301a23eab77b4" => :yosemite
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    mkdir_p "src/github.com/hyperhq"
    ln_s buildpath, "src/github.com/hyperhq/hypercli"
    system "./build.sh"
    bin.install "hyper/hyper"
  end

  test do
    system "#{bin}/hyper", "--help"
  end
end
