require "language/go"

class Gx < Formula
  desc "The language-agnostic, universal package manager"
  homepage "https://github.com/whyrusleeping/gx"
  url "https://github.com/whyrusleeping/gx/archive/v0.12.0.tar.gz"
  sha256 "a42ebd0d886b772c5315afc9e8eaf4012fdabc1bcbb4d6eb4f6d2977d6375c41"
  head "https://github.com/whyrusleeping/gx.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "a0eafb523a441fb36f28b27836919d0c86a0004c0848a3a37c7ea860fd299618" => :sierra
    sha256 "b334229a26c963e4faf2a6afdbe1abff2dbd3f4ca63777bea0125947a058b246" => :el_capitan
    sha256 "9baeffdf12aec560287b462363da859cf1e5d49cd21a2e315bcbb11fd819d793" => :yosemite
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

  go_resource "github.com/btcsuite/btcd" do
    url "https://github.com/btcsuite/btcd.git",
        :revision => "9822ffad6802d3b902442b727a238230194d961f"
  end

  go_resource "github.com/codegangsta/cli" do
    url "https://github.com/codegangsta/cli.git",
        :revision => "4b90d79a682b4bf685762c7452db20f2a676ecb2"
  end

  go_resource "github.com/coreos/go-semver" do
    url "https://github.com/coreos/go-semver.git",
        :revision => "1817cd4bea52af76542157eeabd74b057d1a199e"
  end

  go_resource "github.com/gogo/protobuf" do
    url "https://github.com/gogo/protobuf.git",
        :revision => "dda3e8acadcc9affc16faf33fbb229db78399245"
  end

  go_resource "github.com/ipfs/go-ipfs-api" do
    url "https://github.com/ipfs/go-ipfs-api.git",
        :revision => "2da86eb64d56571c123c02ae82140c7b4b95f72a"
  end

  go_resource "github.com/ipfs/go-ipfs-util" do
    url "https://github.com/ipfs/go-ipfs-util.git",
        :revision => "f25fcc891281327394bb48000ef0970d11baff2b"
  end

  go_resource "github.com/ipfs/go-log" do
    url "https://github.com/ipfs/go-log.git",
        :revision => "48d644b006ba26f1793bffc46396e981801078e3"
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
        :revision => "a922092abea58f07c32eabe303ec817569578740"
  end

  go_resource "github.com/libp2p/go-libp2p-crypto" do
    url "https://github.com/libp2p/go-libp2p-crypto.git",
        :revision => "e89e1de117dd65c6129d99d1d853f48bc847cf17"
  end

  go_resource "github.com/libp2p/go-libp2p-host" do
    url "https://github.com/libp2p/go-libp2p-host.git",
        :revision => "c1fc482de113ce7e4cdc9453a1c1c0fe4164d985"
  end

  go_resource "github.com/libp2p/go-libp2p-interface-conn" do
    url "https://github.com/libp2p/go-libp2p-interface-conn.git",
        :revision => "95afdbf0c900237f3b9104f1f7cfd3d56175a241"
  end

  go_resource "github.com/libp2p/go-libp2p-net" do
    url "https://github.com/libp2p/go-libp2p-net.git",
        :revision => "2680a9894c7aabada540f728a53d7c1a16a1a44a"
  end

  go_resource "github.com/libp2p/go-libp2p-peer" do
    url "https://github.com/libp2p/go-libp2p-peer.git",
        :revision => "166a39e33e7a2a47a4bf999264f254ecaa4fe232"
  end

  go_resource "github.com/libp2p/go-libp2p-peerstore" do
    url "https://github.com/libp2p/go-libp2p-peerstore.git",
        :revision => "744a149e48eb42e032540507c8545d12cc3b7f6f"
  end

  go_resource "github.com/libp2p/go-libp2p-protocol" do
    url "https://github.com/libp2p/go-libp2p-protocol.git",
        :revision => "40488c03777c16bfcd65da2f675b192863cbc2dc"
  end

  go_resource "github.com/libp2p/go-libp2p-transport" do
    url "https://github.com/libp2p/go-libp2p-transport.git",
        :revision => "5d3cb5861b59c26052a5fe184e45c381ec17e22d"
  end

  go_resource "github.com/libp2p/go-maddr-filter" do
    url "https://github.com/libp2p/go-maddr-filter.git",
        :revision => "90aacb5ee155f0d6f3fa8b34d775de842606c0b1"
  end

  go_resource "github.com/mitchellh/go-homedir" do
    url "https://github.com/mitchellh/go-homedir.git",
        :revision => "b8bc1bf767474819792c23f32d8286a45736f1c6"
  end

  go_resource "github.com/multiformats/go-multiaddr" do
    url "https://github.com/multiformats/go-multiaddr.git",
        :revision => "33741da7b3f5773a599d4a03c333704fc560ef34"
  end

  go_resource "github.com/multiformats/go-multiaddr-net" do
    url "https://github.com/multiformats/go-multiaddr-net.git",
        :revision => "a7b93d11855f04f56908e1385991eb6a400fcc43"
  end

  go_resource "github.com/multiformats/go-multihash" do
    url "https://github.com/multiformats/go-multihash.git",
        :revision => "a52a6a4768da72eba89ea7f59f70e9d42ddd3072"
  end

  go_resource "github.com/multiformats/go-multistream" do
    url "https://github.com/multiformats/go-multistream.git",
        :revision => "b8f1996688ab586031517919b49b1967fca8d5d9"
  end

  go_resource "github.com/sabhiram/go-git-ignore" do
    url "https://github.com/sabhiram/go-git-ignore.git",
        :revision => "87c28ffedb6cb7ff29ae89e0440e9ddee0d95a9e"
  end

  go_resource "github.com/spaolacci/murmur3" do
    url "https://github.com/spaolacci/murmur3.git",
        :revision => "0d12bf811670bf6a1a63828dfbd003eded177fce"
  end

  go_resource "github.com/whyrusleeping/go-logging" do
    url "https://github.com/whyrusleeping/go-logging.git",
        :revision => "0457bb6b88fc1973573aaf6b5145d8d3ae972390"
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
        :revision => "15300f9d3a2d71db61951a8705d5ea8878764837"
  end

  go_resource "github.com/whyrusleeping/progmeter" do
    url "https://github.com/whyrusleeping/progmeter.git",
        :revision => "974d8fe8cd87585865b1370184050e89d606e817"
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
        :revision => "a48ac81e47fd6f9ed1258f3b60ae9e75f93cb7ed"
  end

  go_resource "leb.io/hashland" do
    url "https://github.com/tildeleb/hashland.git",
        :revision => "e13accbe55f7fa03c73c74ace4cca4c425e47260"
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
