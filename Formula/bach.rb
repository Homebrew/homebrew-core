require "language/go"

class Bach < Formula
  desc "Command-line for the Compose API"
  homepage "https://github.com/compose/bach"
  url "https://github.com/compose/bach/archive/0.0.10.tar.gz"
  sha256 "1e42ffd2e172384420efe86fb066e66696b548872edf72dbade22c3f71fb5725"

  head "https://github.com/compose/bach.git"

  depends_on "go" => :build

  go_resource "github.com/compose/gocomposeapi" do
    url "https://github.com/compose/gocomposeapi.git",
      :revision => "55c2f98e26b06cb48126ce672af309c8bdfae6ee"
  end

  go_resource "github.com/fsnotify/fsnotify" do
    url "https://github.com/fsnotify/fsnotify.git",
      :revision => "4da3e2cfbabc9f751898f250b49f2439785783a1"
  end

  go_resource "github.com/hashicorp/hcl" do
    url "https://github.com/hashicorp/hcl.git",
      :revision => "392dba7d905ed5d04a5794ba89f558b27e2ba1ca"
  end

  go_resource "github.com/magiconair/properties" do
    url "https://github.com/magiconair/properties.git",
      :revision => "51463bfca2576e06c62a8504b5c0f06d61312647"
  end

  go_resource "github.com/mitchellh/mapstructure" do
    url "https://github.com/mitchellh/mapstructure.git",
      :revision => "d0303fe809921458f417bcf828397a65db30a7e4"
  end

  go_resource "github.com/pelletier/go-buffruneio" do
    url "https://github.com/pelletier/go-buffruneio.git",
      :revision => "c37440a7cf42ac63b919c752ca73a85067e05992"
  end

  go_resource "github.com/pelletier/go-toml" do
    url "https://github.com/pelletier/go-toml.git",
      :revision => "fe7536c3dee2596cdd23ee9976a17c22bdaae286"
  end

  go_resource "github.com/spf13/afero" do
    url "https://github.com/spf13/afero.git",
      :revision => "9be650865eab0c12963d8753212f4f9c66cdcf12"
  end

  go_resource "github.com/spf13/cast" do
    url "https://github.com/spf13/cast.git",
      :revision => "acbeb36b902d72a7a4c18e8f3241075e7ab763e4"
  end

  go_resource "github.com/spf13/cobra" do
    url "https://github.com/spf13/cobra.git",
      :revision => "d7cfb134748502f60bc1797cd26fcc3e4eb4b927"
  end

  go_resource "github.com/spf13/jwalterweatherman" do
    url "https://github.com/spf13/jwalterweatherman.git",
      :revision => "0efa5202c04663c757d84f90f5219c1250baf94f"
  end

  go_resource "github.com/spf13/pflag" do
    url "https://github.com/spf13/pflag.git",
      :revision => "e57e3eeb33f795204c1ca35f56c44f83227c6e66"
  end

  go_resource "github.com/spf13/viper" do
    url "https://github.com/spf13/viper.git",
      :revision => "a1ecfa6a20bd4ef9e9caded262ee1b1b26847675"
  end

  go_resource "golang.org/x/sys" do
    url "https://go.googlesource.com/sys.git",
      :revision => "0b25a408a50076fbbcae6b7ac0ea5fbb0b085e79"
  end

  go_resource "golang.org/x/text" do
    url "https://go.googlesource.com/text.git",
      :revision => "210eee5cf7323015d097341bcf7166130d001cd8"
  end

  go_resource "gopkg.in/yaml.v2" do
    url "https://gopkg.in/yaml.v2.git",
      :revision => "cd8b52f8269e0feb286dfeef29f8fe4d5b397e0b"
  end

  def install
    rm_rf "vendor" # fix for https://github.com/compose/bach/issues/13

    ENV["GOPATH"] = buildpath

    (buildpath/"src/github.com/compose").mkpath
    ln_s buildpath, "src/github.com/compose/bach"

    Language::Go.stage_deps resources, buildpath/"src"

    system "go", "build", "-o", "bin/bach", "github.com/compose/bach"
    bin.install "bin/bach"
  end

  test do
    system bin/"bach", "about"
  end
end
