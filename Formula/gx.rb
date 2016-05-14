require "language/go"

class Gx < Formula
  desc "The language-agnostic, universal package manager"
  homepage "https://github.com/whyrusleeping/gx"
  url "https://github.com/whyrusleeping/gx.git",
    :tag => "v0.4.0",
    :revision => "b82b91b0cf30023c277903ab1ed6b158e80d5d23"
  head "https://github.com/whyrusleeping/gx.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "2728f6c0132ac57e5489d54edbbe609f0b83338bf73006b7b84490cbae526993" => :el_capitan
    sha256 "9a61784cd3f38f9a48b85c6f5d39aec9cb1d2fd2e8ea3760d5754329d3811f5c" => :yosemite
    sha256 "840291aca84a9951cbce5d2994fcd270b91f9d3e2ad746c24ec827c1e5ffd6e3" => :mavericks
  end

  depends_on "go" => :build
  depends_on "godep" => :build

  go_resource "github.com/blang/semver" do
    url "https://github.com/blang/semver.git",
      :revision => "aea32c919a18e5ef4537bbd283ff29594b1b0165"
  end

  go_resource "github.com/codegangsta/cli" do
    url "https://github.com/codegangsta/cli.git",
      :revision => "71f57d300dd6a780ac1856c005c4b518cfd498ec"
  end

  go_resource "github.com/whyrusleeping/stump" do
    url "https://github.com/whyrusleeping/stump.git",
      :revision => "bdc01b1f13fc5bed17ffbf4e0ed7ea17fd220ee6"
  end

  go_resource "github.com/whyrusleeping/gx" do
    url "https://github.com/whyrusleeping/gx.git",
      :revision => "b82b91b0cf30023c277903ab1ed6b158e80d5d23"
  end

  go_resource "github.com/jbenet/go-multiaddr-net" do
    url "https://github.com/jbenet/go-multiaddr-net.git",
      :revision => "4a8bd8f8baf45afcf2bb385bbc17e5208d5d4c71"
  end

  go_resource "github.com/jbenet/go-multiaddr" do
    url "https://github.com/jbenet/go-multiaddr.git",
      :revision => "41d11170520e5b0ea0af2489d7ac5fbdd452e603"
  end

  go_resource "github.com/jbenet/go-multihash" do
    url "https://github.com/jbenet/go-multihash.git",
      :revision => "e8d2374934f16a971d1e94a864514a21ac74bf7f"
  end

  go_resource "github.com/sabhiram/go-git-ignore" do
    url "https://github.com/sabhiram/go-git-ignore.git",
      :revision => "228fcfa2a06e870a3ef238d54c45ea847f492a37"
  end

  go_resource "github.com/ipfs/go-ipfs-api" do
    url "https://github.com/ipfs/go-ipfs-api.git",
      :revision => "1e3445c6574212ffd7d5536e5ec77713debe1f32"
  end

  go_resource "github.com/jbenet/go-base58" do
    url "https://github.com/jbenet/go-base58.git",
      :revision => "6237cf65f3a6f7111cd8a42be3590df99a66bc7d"
  end

  go_resource "golang.org/x/crypto" do
    url "https://go.googlesource.com/crypto.git",
    :revision => "3fbbcd23f1cb824e69491a5930cfeff09b12f4d2"
  end

  go_resource "github.com/whyrusleeping/go-multipart-files" do
    url "https://github.com/whyrusleeping/go-multipart-files.git",
      :revision => "3be93d9f6b618f2b8564bfb1d22f1e744eabbae2"
  end

  go_resource "github.com/whyrusleeping/tar-utils" do
    url "https://github.com/whyrusleeping/tar-utils.git",
      :revision => "beab27159606f5a7c978268dd1c3b12a0f1de8a7"
  end

  def install
    ENV["GOPATH"] = buildpath
    Language::Go.stage_deps resources, buildpath/"src"

    system "go", "build", "-o", "gx"
    bin.install "gx"
  end

  test do
    system "#{bin}/gx", "help"
  end
end
