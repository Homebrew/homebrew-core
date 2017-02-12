require "language/go"

class Gx < Formula
  desc "The language-agnostic, universal package manager"
  homepage "https://github.com/whyrusleeping/gx"
  url "https://github.com/whyrusleeping/gx/archive/v0.11.0.tar.gz"
  sha256 "d2d8113e9b13ce767c2b428e076b431b4d25a1aaf0f4ca26c5b52c8c75d41e78"
  head "https://github.com/whyrusleeping/gx.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "fe55483810f61c0450e6b641bcd6a40d018ade352b48af8bea5e4c9d42d01922" => :sierra
    sha256 "4b665ab8a2f5d04627927cd6f002fc8143c5a3f2a3052a6110958727e95332dd" => :el_capitan
    sha256 "21e788c9dbbe437b554989cb89d5cef46aa8f99b7c91c83903d83ba8192d5e9f" => :yosemite
  end

  depends_on "go" => :build

  go_resource "github.com/agl/ed25519" do
    url "https://github.com/agl/ed25519.git",
        :revision => "5312a61534124124185d41f09206b9fef1d88403"
  end

  go_resource "github.com/blang/semver" do
    url "https://github.com/blang/semver.git",
        :revision => "4a1e882c79dcf4ec00d2e29fac74b9c8938d5052"
  end

  go_resource "github.com/codegangsta/cli" do
    url "https://github.com/codegangsta/cli.git",
        :revision => "347a9884a87374d000eec7e6445a34487c1f4a2b"
  end

  go_resource "github.com/coreos/go-semver" do
    url "https://github.com/coreos/go-semver.git",
        :revision => "5e3acbb5668c4c3deb4842615c4098eb61fb6b1e"
  end

  go_resource "github.com/gogo/protobuf" do
    url "https://github.com/gogo/protobuf.git",
        :revision => "9c5b7bafbfccf2b40d274e0496f3a09418a87af4"
  end

  go_resource "github.com/ipfs/go-ipfs-api" do
    url "https://github.com/ipfs/go-ipfs-api.git",
        :revision => "8e5f622a684e7a121ae7e02e705c15d101ea7ee4"
  end

  go_resource "github.com/ipfs/go-ipfs-util" do
    url "https://github.com/ipfs/go-ipfs-util.git",
        :revision => "78188a11e9b4e58e58d37b124fd43afcbef90ec8"
  end

  go_resource "github.com/ipfs/go-log" do
    url "https://github.com/ipfs/go-log.git",
        :revision => "7c24d3c8b0889a7091d7f3618b9ad32b575db2c6"
  end

  go_resource "github.com/jbenet/go-base58" do
    url "https://github.com/jbenet/go-base58.git",
        :revision => "6237cf65f3a6f7111cd8a42be3590df99a66bc7d"
  end

  go_resource "github.com/jbenet/go-os-rename" do
    url "https://github.com/jbenet/go-os-rename.git",
        :revision => "3ac97f61ef67a6b87b95c1282f6c317ed0e693c2"
  end

  go_resource "github.com/jbenet/goprocess" do
    url "https://github.com/jbenet/goprocess.git",
        :revision => "b497e2f366b8624394fb2e89c10ab607bebdde0b"
  end

  go_resource "github.com/libp2p/go-floodsub" do
    url "https://github.com/libp2p/go-floodsub.git",
        :revision => "d146a584e87fba56777f098b618a264ff3546179"
  end

  go_resource "github.com/libp2p/go-libp2p-crypto" do
    url "https://github.com/libp2p/go-libp2p-crypto.git",
        :revision => "3cbc28d032123916de2d0e49bdf1136326458663"
  end

  go_resource "github.com/libp2p/go-libp2p-host" do
    url "https://github.com/libp2p/go-libp2p-host.git",
        :revision => "153b573c9ed1cda19e3a4181f60c29064ded8fe4"
  end

  go_resource "github.com/libp2p/go-libp2p-interface-conn" do
    url "https://github.com/libp2p/go-libp2p-interface-conn.git",
        :revision => "78121c6f62af87b5fa85efe460c795e0a0ba2b34"
  end

  go_resource "github.com/libp2p/go-libp2p-net" do
    url "https://github.com/libp2p/go-libp2p-net.git",
        :revision => "1b6baef1b00b86b6977839e44eac96b447bb0881"
  end

  go_resource "github.com/libp2p/go-libp2p-peer" do
    url "https://github.com/libp2p/go-libp2p-peer.git",
        :revision => "c022ceb0fa13102215b64c5f86a53ec1684c7615"
  end

  go_resource "github.com/libp2p/go-libp2p-peerstore" do
    url "https://github.com/libp2p/go-libp2p-peerstore.git",
        :revision => "9b13cae8e03bd2fdc46283d2af5f95bf9c82c77b"
  end

  go_resource "github.com/libp2p/go-libp2p-protocol" do
    url "https://github.com/libp2p/go-libp2p-protocol.git",
        :revision => "40488c03777c16bfcd65da2f675b192863cbc2dc"
  end

  go_resource "github.com/libp2p/go-libp2p-transport" do
    url "https://github.com/libp2p/go-libp2p-transport.git",
        :revision => "63cfec9f189253ed1f1e624e11df5367909bdd4a"
  end

  go_resource "github.com/libp2p/go-maddr-filter" do
    url "https://github.com/libp2p/go-maddr-filter.git",
        :revision => "d5b83eac5f7d67a79bbe653443e07784f7cb6952"
  end

  go_resource "github.com/mitchellh/go-homedir" do
    url "https://github.com/mitchellh/go-homedir.git",
        :revision => "b8bc1bf767474819792c23f32d8286a45736f1c6"
  end

  go_resource "github.com/multiformats/go-multiaddr" do
    url "https://github.com/multiformats/go-multiaddr.git",
        :revision => "5ea81f9b8a5b2d6b68af026b5899bd06cd5e0396"
  end

  go_resource "github.com/multiformats/go-multiaddr-net" do
    url "https://github.com/multiformats/go-multiaddr-net.git",
        :revision => "1854460b3710255985878ebf409f4002df88bb0b"
  end

  go_resource "github.com/multiformats/go-multihash" do
    url "https://github.com/multiformats/go-multihash.git",
        :revision => "d6ebd610a180b411b34dba68aa29b651b312281a"
  end

  go_resource "github.com/multiformats/go-multistream" do
    url "https://github.com/multiformats/go-multistream.git",
        :revision => "661a0b9a0e6d9e99e4552c431b0eb82f58fde5b3"
  end

  go_resource "github.com/sabhiram/go-git-ignore" do
    url "https://github.com/sabhiram/go-git-ignore.git",
        :revision => "87c28ffedb6cb7ff29ae89e0440e9ddee0d95a9e"
  end

  go_resource "github.com/whyrusleeping/go-logging" do
    url "https://github.com/whyrusleeping/go-logging.git",
        :revision => "0a5b4a6decf577ce8293eca85ec733d7ab92d742"
  end

  go_resource "github.com/whyrusleeping/go-multipart-files" do
    url "https://github.com/whyrusleeping/go-multipart-files.git",
        :revision => "3be93d9f6b618f2b8564bfb1d22f1e744eabbae2"
  end

  go_resource "github.com/whyrusleeping/json-filter" do
    url "https://github.com/whyrusleeping/json-filter.git",
        :revision => "ff25329a9528f01c5175414f16cc0a6a162a5b8b"
  end

  go_resource "github.com/whyrusleeping/mafmt" do
    url "https://github.com/whyrusleeping/mafmt.git",
        :revision => "f052f16d5bc5e910bfeb695a91914378be0eadce"
  end

  go_resource "github.com/whyrusleeping/stump" do
    url "https://github.com/whyrusleeping/stump.git",
        :revision => "206f8f13aae1697a6fc1f4a55799faf955971fc5"
  end

  go_resource "github.com/whyrusleeping/tar-utils" do
    url "https://github.com/whyrusleeping/tar-utils.git",
        :revision => "beab27159606f5a7c978268dd1c3b12a0f1de8a7"
  end

  go_resource "github.com/whyrusleeping/timecache" do
    url "https://github.com/whyrusleeping/timecache.git",
        :revision => "cfcb2f1abfee846c430233aef0b630a946e0a5a6"
  end

  go_resource "golang.org/x/crypto" do
    url "https://go.googlesource.com/crypto.git",
        :revision => "453249f01cfeb54c3d549ddb75ff152ca243f9d8"
  end

  def install
    ENV["GOPATH"] = buildpath
    mkdir_p "src/github.com/whyrusleeping"
    ln_s buildpath, "src/github.com/whyrusleeping/gx"
    Language::Go.stage_deps resources, buildpath/"src"
    system "go", "build", "-o", bin/"gx"
  end

  test do
    system bin/"gx", "help"
  end
end
