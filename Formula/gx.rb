require "language/go"

class Gx < Formula
  desc "The language-agnostic, universal package manager"
  homepage "https://github.com/whyrusleeping/gx"
  url "https://github.com/whyrusleeping/gx/archive/v0.12.1.tar.gz"
  sha256 "c3e98d26bf5d42cf98ecd041db84b30296918a219d9fb5df2ede1067332e579e"
  head "https://github.com/whyrusleeping/gx.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "9ba20341edc54d60bc59955d8e4c5b458983c3f07220b63e9694460a47a52d3f" => :high_sierra
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
        :revision => "2ee87856327ba09384cabd113bc6b5d174e9ec0f"
  end

  go_resource "github.com/btcsuite/btcd" do
    url "https://github.com/btcsuite/btcd.git",
        :revision => "8cea3866d0f7fb12d567a20744942c0d078c7d15"
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

  go_resource "github.com/urfave/cli" do
    url "https://github.com/urfave/cli.git",
        :revision => "7ace96b43d4bdc46f81d0d1219742b2469874cf6"
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
    ln_s buildpath, "src/github.com/whyrusleeping/gx"
    Language::Go.stage_deps resources, buildpath/"src"
    system "go", "build", "-o", bin/"gx"
  end

  test do
    system bin/"gx", "help"
  end
end
