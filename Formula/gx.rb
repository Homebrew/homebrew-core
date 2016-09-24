require "language/go"

class Gx < Formula
  desc "The language-agnostic, universal package manager"
  homepage "https://github.com/whyrusleeping/gx"
  url "https://github.com/whyrusleeping/gx/archive/v0.9.1.tar.gz"
  sha256 "ba01c0f45f2591ee8b0f4bd561aa95df93415881ff0ffb380a1774afe41302c7"
  head "https://github.com/whyrusleeping/gx.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "66e63b7d142c50c813b576071944a5fe971c895589618805223a3e4e3d8f88c1" => :el_capitan
    sha256 "729fe2ca87480428a5dae523b7c14cc72482d83be365813100e3a8b731ce5d43" => :yosemite
    sha256 "b4b9e265d15eefb007379e5492ca89974331511e1cf0510f06f5df22dd1a6245" => :mavericks
  end

  depends_on "go" => :build

  go_resource "github.com/blang/semver" do
    url "https://github.com/blang/semver.git",
        :revision => "60ec3488bfea7cca02b021d106d9911120d25fe9"
  end

  go_resource "github.com/codegangsta/cli" do
    url "https://github.com/codegangsta/cli.git",
        :revision => "61f519fe5e57c2518c03627b194899a105838eba"
  end

  go_resource "github.com/ipfs/go-ipfs-api" do
    url "https://github.com/ipfs/go-ipfs-api.git",
        :revision => "591ed9cdb542b0db25818cfab701d3772863e9ba"
  end

  go_resource "github.com/ipfs/go-ipfs" do
    url "https://github.com/ipfs/go-ipfs.git",
        :revision => "85da76a4eea9098d5874c168c728591d1d2f58a1"
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
        :revision => "119f50887f8fe324fe2386421c27a11af014b64e"
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
