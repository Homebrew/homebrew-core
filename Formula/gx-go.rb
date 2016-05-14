require "language/go"

class GxGo < Formula
  desc "Tool to use with the gx package manager for packages written in go."
  homepage "https://github.com/whyrusleeping/gx-go"
  url "https://github.com/whyrusleeping/gx-go.git",
    :tag => "v1.2.0",
    :revision => "1fd3e84312ff558b7020a732207910d6c491d5e4"
  head "https://github.com/whyrusleeping/gx-go.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "b58491214709f6533091730ecae2c576a67a50f670118a32154589df57a5868f" => :el_capitan
    sha256 "f3a76ad2a23382cc1d0e93f3682c725f88e79041484474ddaf581dbf374a466f" => :yosemite
    sha256 "a765c025534def27e6b52176ee3dc85907807872e86943661d04c9f243e15e88" => :mavericks
  end

  depends_on "go" => :build
  depends_on "godep" => :build
  depends_on "gx"

  go_resource "github.com/codegangsta/cli" do
    url "https://github.com/codegangsta/cli.git",
      :revision => "71f57d300dd6a780ac1856c005c4b518cfd498ec"
  end

  go_resource "github.com/whyrusleeping/gx-go" do
    url "https://github.com/whyrusleeping/gx-go.git",
      :revision => "e5258e8126435420207a15d914c895e076177af4"
  end

  go_resource "github.com/whyrusleeping/gx" do
    url "https://github.com/whyrusleeping/gx.git",
      :revision => "b82b91b0cf30023c277903ab1ed6b158e80d5d23"
  end

  go_resource "github.com/kr/fs" do
    url "https://github.com/kr/fs.git",
      :revision => "2788f0dbd16903de03cb8186e5c7d97b69ad387b"
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

  go_resource "github.com/whyrusleeping/stump" do
    url "https://github.com/whyrusleeping/stump.git",
      :revision => "bdc01b1f13fc5bed17ffbf4e0ed7ea17fd220ee6"
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

    system "go", "build", "-o", "gx-go"
    bin.install "gx-go"
  end

  test do
    system "#{bin}/gx-go", "help"
  end
end
