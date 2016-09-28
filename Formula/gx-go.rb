require "language/go"

class GxGo < Formula
  desc "Tool to use with the gx package manager for packages written in go."
  homepage "https://github.com/whyrusleeping/gx-go"
  url "https://github.com/whyrusleeping/gx-go/archive/v1.3.0.tar.gz"
  sha256 "68f8330ed80e84cc3466a2954a1c49d7380971f02f43a7c72ed7b65f85e91710"
  head "https://github.com/whyrusleeping/gx-go.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "10bd6bb218692cc95333b3a69c51dc003331ea79f49b629823a67ef3794916a0" => :sierra
    sha256 "44d9c3dfd5cf95085c7195c989c7c010c6a32395a9fa99cee24e204630674303" => :el_capitan
    sha256 "fb3d64a2a1f09e6f965f4f924644031015d3f1a5687d110ae5838c57b3b71154" => :yosemite
    sha256 "0da3f20f2f43cbf1b2186f75f8107d3ae42989f30a48569b7dd5d70ba1aabf5a" => :mavericks
  end

  depends_on "go" => :build

  go_resource "github.com/codegangsta/cli" do
    url "https://github.com/codegangsta/cli.git",
        :revision => "05fe449c81eb7305a34e9253c321c960a1c5e057"
  end

  go_resource "github.com/ipfs/go-ipfs-api" do
    url "https://github.com/ipfs/go-ipfs-api.git",
        :revision => "49d8bc426f918f3d5c0cc721e61e820c2f94943c"
  end

  go_resource "github.com/jbenet/go-base58" do
    url "https://github.com/jbenet/go-base58.git",
        :revision => "6237cf65f3a6f7111cd8a42be3590df99a66bc7d"
  end

  go_resource "github.com/jbenet/go-multiaddr" do
    url "https://github.com/jbenet/go-multiaddr.git",
        :revision => "1dd0034f7fe862dd8dc86a02602ff6f9e546f5fe"
  end

  go_resource "github.com/jbenet/go-multiaddr-net" do
    url "https://github.com/jbenet/go-multiaddr-net.git",
        :revision => "ff394cdaae087d110150f15418ea4585c23541c6"
  end

  go_resource "github.com/jbenet/go-multihash" do
    url "https://github.com/jbenet/go-multihash.git",
        :revision => "5bb8e87657d874eea0af6366dc6336c4d819e7c1"
  end

  go_resource "github.com/jbenet/go-os-rename" do
    url "https://github.com/jbenet/go-os-rename.git",
        :revision => "3ac97f61ef67a6b87b95c1282f6c317ed0e693c2"
  end

  go_resource "github.com/kr/fs" do
    url "https://github.com/kr/fs.git",
        :revision => "2788f0dbd16903de03cb8186e5c7d97b69ad387b"
  end

  go_resource "github.com/mitchellh/go-homedir" do
    url "https://github.com/mitchellh/go-homedir.git",
        :revision => "756f7b183b7ab78acdbbee5c7f392838ed459dda"
  end

  go_resource "github.com/sabhiram/go-git-ignore" do
    url "https://github.com/sabhiram/go-git-ignore.git",
        :revision => "228fcfa2a06e870a3ef238d54c45ea847f492a37"
  end

  go_resource "github.com/whyrusleeping/go-multipart-files" do
    url "https://github.com/whyrusleeping/go-multipart-files.git",
        :revision => "3be93d9f6b618f2b8564bfb1d22f1e744eabbae2"
  end

  go_resource "github.com/whyrusleeping/gx" do
    url "https://github.com/whyrusleeping/gx.git",
        :revision => "7769c5d1c59ddc1013e8454bdd1f5a0c834e82fa"
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
        :revision => "b35ccbc95a0eaae49fb65c5d627cb7149ed8d1ab"
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
