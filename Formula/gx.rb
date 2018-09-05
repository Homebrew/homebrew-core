require "language/go"

class Gx < Formula
  desc "The language-agnostic, universal package manager"
  homepage "https://github.com/whyrusleeping/gx"
  url "https://github.com/whyrusleeping/gx/archive/v0.13.0.tar.gz"
  sha256 "c93e96170c6e161176cfca5a866072ec2e79a85b6185bc4cefcf3fc62b0e7c4f"
  head "https://github.com/whyrusleeping/gx.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "38573e9fdb5837218dcbe12c44b034888f5d1ed969dbae4225a8152d66a2a9d7" => :mojave
    sha256 "b0f7b7d33126e4af1856da3d2bf4a6b314e2d44b182cf66be65744f6d961eb6b" => :high_sierra
    sha256 "0e4f02f886f828c6c600cb98c383549fc66c5f37ffed8a8232c4821b0896ff81" => :sierra
    sha256 "93b7c70f8c93b2d4678766a3a69780b4128bf21f2f4a0f3261b77183fad318a6" => :el_capitan
  end

  depends_on "go" => :build

  go_resource "github.com/agl/ed25519" do
    url "https://github.com/agl/ed25519.git",
        :revision => "5312a61534124124185d41f09206b9fef1d88403"
  end

  go_resource "github.com/blang/semver" do
    url "https://github.com/blang/semver.git",
        :revision => "c5e971dbed7850a93c23aa6ff69db5771d8e23b3"
  end

  go_resource "github.com/btcsuite/btcd" do
    url "https://github.com/btcsuite/btcd.git",
        :revision => "675abc5df3c5531bc741b56a765e35623459da6d"
  end

  go_resource "github.com/gogo/protobuf" do
    url "https://github.com/gogo/protobuf.git",
        :revision => "30cf7ac33676b5786e78c746683f0d4cd64fa75b"
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
        :revision => "a031ab4d1b8142714eec946acb7033abafade3d7"
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

  go_resource "github.com/sabhiram/go-git-ignore" do
    url "https://github.com/sabhiram/go-git-ignore.git",
        :revision => "fc6676d5d4e5b94d6530686eecb94f85b44cdc39"
  end

  go_resource "github.com/spaolacci/murmur3" do
    url "https://github.com/spaolacci/murmur3.git",
        :revision => "f09979ecbc725b9e6d41a297405f65e7e8804acc"
  end

  go_resource "github.com/urfave/cli" do
    url "https://github.com/urfave/cli.git",
        :revision => "8e01ec4cd3e2d84ab2fe90d8210528ffbb06d8ff"
  end

  go_resource "github.com/whyrusleeping/go-logging" do
    url "https://github.com/whyrusleeping/go-logging.git",
        :revision => "0457bb6b88fc1973573aaf6b5145d8d3ae972390"
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
    ln_s buildpath, "src/github.com/whyrusleeping/gx"
    Language::Go.stage_deps resources, buildpath/"src"
    system "go", "build", "-o", bin/"gx"
  end

  test do
    system bin/"gx", "help"
  end
end
