require "language/go"

class Gx < Formula
  desc "The language-agnostic, universal package manager"
  homepage "https://github.com/whyrusleeping/gx"
  url "https://github.com/whyrusleeping/gx.git",
    :tag => "v0.7.0",
    :revision => "158f382c2832fd93be476df27c9dc986db410394"
  head "https://github.com/whyrusleeping/gx.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "452d8d246eade68ee4296a3779fb4bcbdc7c264a9f29704ce4e044a17a785ad3" => :el_capitan
    sha256 "6b6a6d5c1c7f81bcbc8ebff3299a2e060db884f45f4e1f57379d3b4eda6dad47" => :yosemite
    sha256 "bcaabcb6afb3bcf79fb32bdc9aac39b2aede3644847e9eb83fe0bda1cf7ca0d0" => :mavericks
  end

  depends_on "go" => :build

  go_resource "github.com/anacrolix/missinggo" do
    url "https://github.com/anacrolix/missinggo.git",
    :revision => "b58ed0d2d777019fbe0b01fb30eb3137826ec4b8"
  end

  go_resource "github.com/anacrolix/sync" do
    url "https://github.com/anacrolix/sync.git",
    :revision => "812602587b72df6a2a4f6e30536adc75394a374b"
  end

  go_resource "github.com/anacrolix/utp" do
    url "https://github.com/anacrolix/utp.git",
    :revision => "d7ad5aff2b8a5fa415d1c1ed00b71cfd8b4c69e0"
  end

  go_resource "github.com/blang/semver" do
    url "https://github.com/blang/semver.git",
    :revision => "e64c75d1c910cd81c8caa1f2cc2c6409dd65af81"
  end

  go_resource "github.com/bradfitz/iter" do
    url "https://github.com/bradfitz/iter.git",
    :revision => "454541ec3da2a73fc34fd049b19ee5777bf19345"
  end

  go_resource "github.com/codegangsta/cli" do
    url "https://github.com/codegangsta/cli.git",
    :revision => "4205e9c4ee9672a8df5bb4fe486a8aa07e1e4037"
  end

  go_resource "github.com/ipfs/go-ipfs-api" do
    url "https://github.com/ipfs/go-ipfs-api.git",
    :revision => "7af57c838d6e950e4d3ecc46b7451b470fe49d62"
  end

  go_resource "github.com/jbenet/go-base58" do
    url "https://github.com/jbenet/go-base58.git",
    :revision => "6237cf65f3a6f7111cd8a42be3590df99a66bc7d"
  end

  go_resource "github.com/jbenet/go-multiaddr" do
    url "https://github.com/jbenet/go-multiaddr.git",
    :revision => "f3dff105e44513821be8fbe91c89ef15eff1b4d4"
  end

  go_resource "github.com/jbenet/go-multiaddr-net" do
    url "https://github.com/jbenet/go-multiaddr-net.git",
    :revision => "d4cfd691db9f50e430528f682ca603237b0eaae0"
  end

  go_resource "github.com/jbenet/go-multihash" do
    url "https://github.com/jbenet/go-multihash.git",
    :revision => "dfd3350f10a27ba2cfcd0e5e2d12c43a69f6e408"
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
    :revision => "811831de4c4dd03a0b8737233af3b36852386373"
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
