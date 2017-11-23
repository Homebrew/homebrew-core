require "language/go"

class GxGo < Formula
  desc "Tool to use with the gx package manager for packages written in go"
  homepage "https://github.com/whyrusleeping/gx-go"
  url "https://github.com/whyrusleeping/gx-go/archive/v1.6.0.tar.gz"
  sha256 "9f7d9ec600a3ce5dd6a04bf99b6fd2248c0a81652c4049ea83e537111b4df856"
  head "https://github.com/whyrusleeping/gx-go.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "b8f5035a637dd15236c01c7edd193b6e786c61a67ec404e2caf4a987cbe3b4a7" => :high_sierra
    sha256 "6241d5081be9d8a376f4fa64edc16350242466a0f7716f82946689145b699102" => :sierra
    sha256 "938b5b269b22301e95d10a6c81c2c151a245a34de358cf90ddf97fb3b35037bf" => :el_capitan
  end

  depends_on "go" => :build

  go_resource "github.com/agl/ed25519" do
    url "https://github.com/agl/ed25519.git",
        :revision => "5312a61534124124185d41f09206b9fef1d88403"
  end

  go_resource "github.com/btcsuite/btcd" do
    url "https://github.com/btcsuite/btcd.git",
        :revision => "8cea3866d0f7fb12d567a20744942c0d078c7d15"
  end

  go_resource "github.com/codegangsta/cli" do
    url "https://github.com/codegangsta/cli.git",
        :revision => "7ace96b43d4bdc46f81d0d1219742b2469874cf6"
  end

  go_resource "github.com/gogo/protobuf" do
    url "https://github.com/gogo/protobuf.git",
        :revision => "616a82ed12d78d24d4839363e8f3c5d3f20627cf"
  end

  go_resource "github.com/ipfs/go-ipfs-api" do
    url "https://github.com/ipfs/go-ipfs-api.git",
        :revision => "08c2643ffe65b5e2dc2785093fa6b006fc9b8402"
  end

  go_resource "github.com/ipfs/go-ipfs-cmdkit" do
    url "https://github.com/ipfs/go-ipfs-cmdkit.git",
        :revision => "f3631e8ddde711a7aefed041806902d907a1f9ae"
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

  go_resource "github.com/kr/fs" do
    url "https://github.com/kr/fs.git",
        :revision => "2788f0dbd16903de03cb8186e5c7d97b69ad387b"
  end

  go_resource "github.com/libp2p/go-libp2p-crypto" do
    url "https://github.com/libp2p/go-libp2p-crypto.git",
        :revision => "e89e1de117dd65c6129d99d1d853f48bc847cf17"
  end

  go_resource "github.com/libp2p/go-libp2p-peer" do
    url "https://github.com/libp2p/go-libp2p-peer.git",
        :revision => "d863b451638c441d046c53834ccfef13beebd025"
  end

  go_resource "github.com/libp2p/go-libp2p-pubsub" do
    url "https://github.com/libp2p/go-libp2p-pubsub.git",
        :revision => "a031ab4d1b8142714eec946acb7033abafade3d7"
  end

  go_resource "github.com/mitchellh/go-homedir" do
    url "https://github.com/mitchellh/go-homedir.git",
        :revision => "b8bc1bf767474819792c23f32d8286a45736f1c6"
  end

  go_resource "github.com/multiformats/go-multiaddr" do
    url "https://github.com/multiformats/go-multiaddr.git",
        :revision => "6a3fc2bc0c9f2cae466f61d658136d8da99e66f5"
  end

  go_resource "github.com/multiformats/go-multiaddr-net" do
    url "https://github.com/multiformats/go-multiaddr-net.git",
        :revision => "376ba58703c84bfff9ca6e0057adf38ad48d3de5"
  end

  go_resource "github.com/multiformats/go-multicodec-packed" do
    url "https://github.com/multiformats/go-multicodec-packed.git",
        :revision => "0ee69486dc1c9087aacfcc575e333f305009997e"
  end

  go_resource "github.com/multiformats/go-multihash" do
    url "https://github.com/multiformats/go-multihash.git",
        :revision => "9f612d271047a209928f7310045cad25250f39c6"
  end

  go_resource "github.com/sabhiram/go-git-ignore" do
    url "https://github.com/sabhiram/go-git-ignore.git",
        :revision => "362f9845770f1606d61ba3ddf9cfb1f0780d2ffe"
  end

  go_resource "github.com/spaolacci/murmur3" do
    url "https://github.com/spaolacci/murmur3.git",
        :revision => "9f5d223c60793748f04a9d5b4b4eacddfc1f755d"
  end

  go_resource "github.com/whyrusleeping/go-logging" do
    url "https://github.com/whyrusleeping/go-logging.git",
        :revision => "0457bb6b88fc1973573aaf6b5145d8d3ae972390"
  end

  go_resource "github.com/whyrusleeping/go-multipart-files" do
    url "https://github.com/whyrusleeping/go-multipart-files.git",
        :revision => "3be93d9f6b618f2b8564bfb1d22f1e744eabbae2"
  end

  go_resource "github.com/whyrusleeping/gx" do
    url "https://github.com/whyrusleeping/gx.git",
        :revision => "89a08d0e93418bb67e807dd8fbd127a525a20cda"
  end

  go_resource "github.com/whyrusleeping/progmeter" do
    url "https://github.com/whyrusleeping/progmeter.git",
        :revision => "30d42a105341e640d284d9920da2078029764980"
  end

  go_resource "github.com/whyrusleeping/stump" do
    url "https://github.com/whyrusleeping/stump.git",
        :revision => "206f8f13aae1697a6fc1f4a55799faf955971fc5"
  end

  go_resource "github.com/whyrusleeping/tar-utils" do
    url "https://github.com/whyrusleeping/tar-utils.git",
        :revision => "beab27159606f5a7c978268dd1c3b12a0f1de8a7"
  end

  go_resource "golang.org/x/crypto" do
    url "https://go.googlesource.com/crypto.git",
        :revision => "9f005a07e0d31d45e6656d241bb5c0f2efd4bc94"
  end

  go_resource "leb.io/hashland" do
    url "https://github.com/tildeleb/hashland.git",
        :revision => "07375b562deaa8d6891f9618a04e94a0b98e2ee7"
  end

  def install
    ENV["GOPATH"] = buildpath
    mkdir_p "src/github.com/whyrusleeping"
    ln_s buildpath, "src/github.com/whyrusleeping/gx-go"
    Language::Go.stage_deps resources, buildpath/"src"
    system "go", "build", "-o", bin/"gx-go"
  end

  test do
    system bin/"gx-go", "help"
  end
end
