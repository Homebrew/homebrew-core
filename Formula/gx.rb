require "language/go"

class Gx < Formula
  desc "The language-agnostic, universal package manager"
  homepage "https://github.com/whyrusleeping/gx"
  url "https://github.com/whyrusleeping/gx/archive/v0.8.0.tar.gz"
  sha256 "aad59957faf228fe6266d30a555b9b569c95f1d45820e858c6dfd9004f9ebfb3"
  head "https://github.com/whyrusleeping/gx.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "2086082991007e8422ae29c52606750af198e086ff88d4b8936cb02303a47203" => :el_capitan
    sha256 "3f7240d4f7fc31af633974c97f9a34efb0672fa43fb439a3834c929a8cfa20d8" => :yosemite
    sha256 "aabe872b28c0e9674dc1827a24b515a7c8252cc1f134e1590df7a7bf31f812e4" => :mavericks
  end

  depends_on "go" => :build

  go_resource "github.com/anacrolix/missinggo" do
    url "https://github.com/anacrolix/missinggo.git",
      :revision => "797fc5dd606f07c7c8af5bed81b61c2a8dccefb0"
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
      :revision => "60ec3488bfea7cca02b021d106d9911120d25fe9"
  end

  go_resource "github.com/bradfitz/iter" do
    url "https://github.com/bradfitz/iter.git",
      :revision => "454541ec3da2a73fc34fd049b19ee5777bf19345"
  end

  go_resource "github.com/codegangsta/cli" do
    url "https://github.com/codegangsta/cli.git",
      :revision => "1efa31f08b9333f1bd4882d61f9d668a70cd902e"
  end

  go_resource "github.com/ipfs/go-ipfs-api" do
    url "https://github.com/ipfs/go-ipfs-api.git",
      :revision => "b683f180dcbe2241e95502f2315622f0bcbb5848"
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
      :revision => "c2f4947f41766b144bb09066e919466da5eddeae"
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
