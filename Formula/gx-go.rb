require "language/go"

class GxGo < Formula
  desc "Tool to use with the gx package manager for packages written in go"
  homepage "https://github.com/whyrusleeping/gx-go"
  url "https://github.com/whyrusleeping/gx-go/archive/v1.9.0.tar.gz"
  sha256 "f3a0ee17359e0e5efab8008361da0e312ca723a0c9e165342a0306caba55a535"
  head "https://github.com/whyrusleeping/gx-go.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "66fa3b40ddb24acbb713379c90df9b398baafd51aa825d5ba28d5fc7781ad987" => :catalina
    sha256 "8c86c8465cde5c6189e67f2d3b758604ef579d064f398cd48eff6ab6ce092bdb" => :mojave
    sha256 "57eb4c948ce99ebca79f938539c1b5e096aef6c16554c30f5744b4e1fc93016d" => :high_sierra
    sha256 "7eb7a89b575a1cb12464f1a0a4d14c5983333a79fb6e4fbb9c5b5240e540020d" => :sierra
  end

  depends_on "go" => :build

  go_resource "github.com/agl/ed25519" do
    url "https://github.com/agl/ed25519.git",
        :revision => "5312a61534124124185d41f09206b9fef1d88403"
  end

  go_resource "github.com/btcsuite/btcd" do
    url "https://github.com/btcsuite/btcd.git",
        :revision => "675abc5df3c5531bc741b56a765e35623459da6d"
  end

  go_resource "github.com/urfave/cli" do
    url "https://github.com/codegangsta/cli.git",
        :revision => "cfb38830724cc34fedffe9a2a29fb54fa9169cd1"
  end

  go_resource "github.com/gogo/protobuf" do
    url "https://github.com/gogo/protobuf.git",
        :revision => "ba06b47c162d49f2af050fb4c75bcbc86a159d5c"
  end

  go_resource "github.com/gxed/hashland" do
    url "https://github.com/gxed/hashland.git",
        :revision => "d9f6b97f8db22dd1e090fd0bbbe98f09cc7dd0a8"
  end

  go_resource "github.com/ipfs/go-ipfs-api" do
    url "https://github.com/ipfs/go-ipfs-api.git",
        :revision => "d204576299ddab1140d043d0abb0d9b60a8a5af4"
  end

  go_resource "github.com/ipfs/go-ipfs-cmdkit" do
    url "https://github.com/ipfs/go-ipfs-cmdkit.git",
        :revision => "c2103d7ae7f889e7329673cc3ba55df8b3863b0f"
  end

  go_resource "github.com/ipfs/go-log" do
    url "https://github.com/ipfs/go-log.git",
        :revision => "0ef81702b797a2ecef05f45dcc82b15298f54355"
  end

  go_resource "github.com/kr/fs" do
    url "https://github.com/kr/fs.git",
        :revision => "1455def202f6e05b95cc7bfc7e8ae67ae5141eba"
  end

  go_resource "github.com/libp2p/go-libp2p-crypto" do
    url "https://github.com/libp2p/go-libp2p-crypto.git",
        :revision => "18915b5467c77ad8c07a35328c2cab468667a4e8"
  end

  go_resource "github.com/libp2p/go-libp2p-peer" do
    url "https://github.com/libp2p/go-libp2p-peer.git",
        :revision => "aa0e03e559bde9d4749ad8e38595e15a6fe808fa"
  end

  go_resource "github.com/libp2p/go-libp2p-pubsub" do
    url "https://github.com/libp2p/go-libp2p-pubsub.git",
        :revision => "f736644fe805a9f5677c82aca25c82da7cde2c76"
  end

  go_resource "github.com/mattn/go-colorable" do
    url "https://github.com/mattn/go-colorable.git",
        :revision => "efa589957cd060542a26d2dd7832fd6a6c6c3ade"
  end

  go_resource "github.com/mattn/go-isatty" do
    url "https://github.com/mattn/go-isatty.git",
        :revision => "6ca4dbf54d38eea1a992b3c722a76a5d1c4cb25c"
  end

  go_resource "github.com/minio/blake2b-simd" do
    url "https://github.com/minio/blake2b-simd.git",
        :revision => "3f5f724cb5b182a5c278d6d3d55b40e7f8c2efb4"
  end

  go_resource "github.com/minio/sha256-simd" do
    url "https://github.com/minio/sha256-simd.git",
        :revision => "ad98a36ba0da87206e3378c556abbfeaeaa98668"
  end

  go_resource "github.com/mitchellh/go-homedir" do
    url "https://github.com/mitchellh/go-homedir.git",
        :revision => "b8bc1bf767474819792c23f32d8286a45736f1c6"
  end

  go_resource "github.com/mr-tron/base58" do
    url "https://github.com/mr-tron/base58.git",
        :revision => "c1bdf7c52f59d6685ca597b9955a443ff95eeee6"
  end

  go_resource "github.com/multiformats/go-multiaddr" do
    url "https://github.com/multiformats/go-multiaddr.git",
        :revision => "123a717755e0559ec8fda308019cd24e0a37bb07"
  end

  go_resource "github.com/multiformats/go-multiaddr-net" do
    url "https://github.com/multiformats/go-multiaddr-net.git",
        :revision => "97d80565f68c5df715e6ba59c2f6a03d1fc33aaf"
  end

  go_resource "github.com/multiformats/go-multihash" do
    url "https://github.com/multiformats/go-multihash.git",
        :revision => "265e72146e710ff649c6982e3699d01d4e9a18bb"
  end

  go_resource "github.com/opentracing/opentracing-go" do
    url "https://github.com/opentracing/opentracing-go.git",
        :revision => "6c572c00d1830223701e155de97408483dfcd14a"
  end

  go_resource "github.com/sabhiram/go-gitignore" do
    url "https://github.com/sabhiram/go-gitignore.git",
        :revision => "fc6676d5d4e5b94d6530686eecb94f85b44cdc39"
  end

  go_resource "github.com/spaolacci/murmur3" do
    url "https://github.com/spaolacci/murmur3.git",
        :revision => "f09979ecbc725b9e6d41a297405f65e7e8804acc"
  end

  go_resource "github.com/whyrusleeping/go-logging" do
    url "https://github.com/whyrusleeping/go-logging.git",
        :revision => "0457bb6b88fc1973573aaf6b5145d8d3ae972390"
  end

  go_resource "github.com/whyrusleeping/gx" do
    url "https://github.com/whyrusleeping/gx.git",
        :revision => "733691bc18c0858a3d7e1a6e0a42df7d0bcac1de"
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
        :revision => "8c6c8ba81d5c71fd69c0f48dbde4b2fb422b6dfc"
  end

  go_resource "golang.org/x/crypto" do
    url "https://go.googlesource.com/crypto.git",
        :revision => "2d027ae1dddd4694d54f7a8b6cbe78dca8720226"
  end

  go_resource "golang.org/x/sys" do
    url "https://go.googlesource.com/sys.git",
        :revision => "d0faeb539838e250bd0a9db4182d48d4a1915181"
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
