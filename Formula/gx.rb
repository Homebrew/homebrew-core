require "language/go"

class Gx < Formula
  desc "The language-agnostic, universal package manager"
  homepage "https://github.com/whyrusleeping/gx"
  url "https://github.com/whyrusleeping/gx/archive/v0.9.0.tar.gz"
  sha256 "887802342e408b7dd61cbdb629586e399742cd4beac22c7b13faa79d85659ea7"
  head "https://github.com/whyrusleeping/gx.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "901e65fc738f676b6e1937a2f9623df42d7b195cdb49252868f6040535a04b71" => :el_capitan
    sha256 "c09251a4705253a1fb92172daebf97c9e8ad3e74251b5b98a341fc8d3d756081" => :yosemite
    sha256 "793c6fe81d3d2440e8dee19c017f0fab5f84cb7234a89afebbb8a882dfe32207" => :mavericks
  end

  depends_on "go" => :build

  go_resource "github.com/blang/semver" do
    url "https://github.com/blang/semver.git",
        :revision => "60ec3488bfea7cca02b021d106d9911120d25fe9"
  end

  go_resource "github.com/codegangsta/cli" do
    url "https://github.com/codegangsta/cli.git",
        :revision => "05fe449c81eb7305a34e9253c321c960a1c5e057"
  end

  go_resource "github.com/ipfs/go-ipfs-api" do
    url "https://github.com/ipfs/go-ipfs-api.git",
        :revision => "49d8bc426f918f3d5c0cc721e61e820c2f94943c"
  end

  go_resource "github.com/ipfs/go-ipfs" do
    url "https://github.com/ipfs/go-ipfs.git",
        :revision => "8830aae9bcef257b11401b7c9e834a3aa107386a"
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

  go_resource "github.com/whyrusleeping/json-filter" do
    url "https://github.com/whyrusleeping/json-filter.git",
        :revision => "ff25329a9528f01c5175414f16cc0a6a162a5b8b"
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
    ln_s buildpath, "src/github.com/whyrusleeping/gx"
    Language::Go.stage_deps resources, buildpath/"src"
    system "go", "build", "-o", bin/"gx"
  end

  test do
    system bin/"gx", "help"
  end
end
