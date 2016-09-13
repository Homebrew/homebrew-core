require "language/go"

class Hugo < Formula
  desc "Configurable static site generator"
  homepage "https://gohugo.io/"
  url "https://github.com/spf13/hugo/archive/v0.16.tar.gz"
  sha256 "a2dbb243535ba69ae8709ffe5ba340951a8834d2c0e86bb76c88d99ad77ef9f5"
  head "https://github.com/spf13/hugo.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "66f87874b65476e5533af35957f435256ad693bc991e7a0226c5bc9ceba4a214" => :sierra
    sha256 "0cb99e96ee6f4a527b63aef496ebbe21baf48113cab9a87e4440d3eb0dfcd57e" => :el_capitan
    sha256 "c4961f3250ea24b60cfd394617c6428bc2211441291e686859e000f4ecf98e57" => :yosemite
    sha256 "14d885b26f4700be6ac3285f138fb87d40d02270645aefbf6f6dca63724b025d" => :mavericks
  end

  depends_on "go" => :build

  go_resource "github.com/BurntSushi/toml" do
    url "https://github.com/BurntSushi/toml.git",
        :revision => "f0aeabca5a127c4078abb8c8d64298b147264b55"
  end

  go_resource "github.com/PuerkitoBio/purell" do
    url "https://github.com/PuerkitoBio/purell.git",
        :revision => "d69616f51cdfcd7514d6a380847a152dfc2a749d"
  end

  go_resource "github.com/bep/inflect" do
    url "https://github.com/bep/inflect.git",
        :revision => "b896c45f5af983b1f416bdf3bb89c4f1f0926f69"
  end

  go_resource "github.com/cpuguy83/go-md2man" do
    url "https://github.com/cpuguy83/go-md2man.git",
        :revision => "2724a9c9051aa62e9cca11304e7dd518e9e41599"
  end

  go_resource "github.com/dchest/cssmin" do
    url "https://github.com/dchest/cssmin.git",
        :revision => "fb8d9b44afdc258bfff6052d3667521babcb2239"
  end

  go_resource "github.com/eknkc/amber" do
    url "https://github.com/eknkc/amber.git",
        :revision => "91774f050c1453128146169b626489e60108ec03"
  end

  go_resource "github.com/fsnotify/fsnotify" do
    url "https://github.com/fsnotify/fsnotify.git",
        :revision => "30411dbcefb7a1da7e84f75530ad3abe4011b4f8"
  end

  go_resource "github.com/gorilla/websocket" do
    url "https://github.com/gorilla/websocket.git",
        :revision => "a68708917c6a4f06314ab4e52493cc61359c9d42"
  end

  go_resource "github.com/hashicorp/hcl" do
    url "https://github.com/hashicorp/hcl.git",
        :revision => "9a905a34e6280ce905da1a32344b25e81011197a"
  end

  go_resource "github.com/kardianos/osext" do
    url "https://github.com/kardianos/osext.git",
        :revision => "29ae4ffbc9a6fe9fb2bc5029050ce6996ea1d3bc"
  end

  go_resource "github.com/kr/fs" do
    url "https://github.com/kr/fs.git",
        :revision => "2788f0dbd16903de03cb8186e5c7d97b69ad387b"
  end

  go_resource "github.com/kyokomi/emoji" do
    url "https://github.com/kyokomi/emoji.git",
        :revision => "17c5e7085c9d59630aa578df67f4469481fbe7a9"
  end

  go_resource "github.com/magiconair/properties" do
    url "https://github.com/magiconair/properties.git",
        :revision => "c265cfa48dda6474e208715ca93e987829f572f8"
  end

  go_resource "github.com/miekg/mmark" do
    url "https://github.com/miekg/mmark.git",
        :revision => "1cc81181240610a61032c944355759771a652f71"
  end

  go_resource "github.com/mitchellh/mapstructure" do
    url "https://github.com/mitchellh/mapstructure.git",
        :revision => "d2dd0262208475919e1a362f675cfc0e7c10e905"
  end

  go_resource "github.com/opennota/urlesc" do
    url "https://github.com/opennota/urlesc.git",
        :revision => "5fa9ff0392746aeae1c4b37fcc42c65afa7a9587"
  end

  go_resource "github.com/pkg/errors" do
    url "https://github.com/pkg/errors.git",
        :revision => "f45f2b7903d2db989402601ad8ec27eff5c1dc9d"
  end

  go_resource "github.com/pkg/sftp" do
    url "https://github.com/pkg/sftp.git",
        :revision => "526cf9b2b38d2f3675e34e473f2cef38e1e0565b"
  end

  go_resource "github.com/russross/blackfriday" do
    url "https://github.com/russross/blackfriday.git",
        :revision => "1d6b8e9301e720b08a8938b8c25c018285885438"
  end

  go_resource "github.com/shurcooL/sanitized_anchor_name" do
    url "https://github.com/shurcooL/sanitized_anchor_name.git",
        :revision => "10ef21a441db47d8b13ebcc5fd2310f636973c77"
  end

  go_resource "github.com/spf13/afero" do
    url "https://github.com/spf13/afero.git",
        :revision => "1a8ecf8b9da1fb5306e149e83128fc447957d2a8"
  end

  go_resource "github.com/spf13/cast" do
    url "https://github.com/spf13/cast.git",
        :revision => "27b586b42e29bec072fe7379259cc719e1289da6"
  end

  go_resource "github.com/spf13/cobra" do
    url "https://github.com/spf13/cobra.git",
        :revision => "f447048345b64b3247b29a679a14bd0da12c7f2f"
  end

  go_resource "github.com/spf13/fsync" do
    url "https://github.com/spf13/fsync.git",
        :revision => "eefee59ad7de621617d4ff085cf768aab4b919b1"
  end

  go_resource "github.com/spf13/hugo" do
    url "https://github.com/spf13/hugo.git",
        :revision => "48ebd598a9da395ae1ba39376b35fdd1105472ce"
  end

  go_resource "github.com/spf13/jwalterweatherman" do
    url "https://github.com/spf13/jwalterweatherman.git",
        :revision => "33c24e77fb80341fe7130ee7c594256ff08ccc46"
  end

  go_resource "github.com/spf13/nitro" do
    url "https://github.com/spf13/nitro.git",
        :revision => "24d7ef30a12da0bdc5e2eb370a79c659ddccf0e8"
  end

  go_resource "github.com/spf13/pflag" do
    url "https://github.com/spf13/pflag.git",
        :revision => "cb88ea77998c3f024757528e3305022ab50b43be"
  end

  go_resource "github.com/spf13/viper" do
    url "https://github.com/spf13/viper.git",
        :revision => "c1ccc378a054ea8d4e38d8c67f6938d4760b53dd"
  end

  go_resource "github.com/stretchr/testify" do
    url "https://github.com/stretchr/testify.git",
        :revision => "8d64eb7173c7753d6419fd4a9caf057398611364"
  end

  go_resource "github.com/yosssi/ace" do
    url "https://github.com/yosssi/ace.git",
        :revision => "71afeb714739f9d5f7e1849bcd4a0a5938e1a70d"
  end

  go_resource "golang.org/x/crypto" do
    url "https://go.googlesource.com/crypto.git",
        :revision => "89d9e62992539701a49a19c52ebb33e84cbbe80f"
  end

  go_resource "golang.org/x/sys" do
    url "https://go.googlesource.com/sys.git",
        :revision => "076b546753157f758b316e59bcb51e6807c04057"
  end

  go_resource "golang.org/x/text" do
    url "https://go.googlesource.com/text.git",
        :revision => "a4d77b4813ec88686efd8caedc113322933f9891"
  end

  go_resource "gopkg.in/yaml.v2" do
    url "https://gopkg.in/yaml.v2.git",
        :revision => "a83829b6f1293c91addabc89d0571c246397bbf4"
  end

  def install
    ENV["GOBIN"] = bin
    ENV["GOPATH"] = buildpath
    ENV["GOHOME"] = buildpath

    mkdir_p buildpath/"src/github.com/spf13/"
    ln_sf buildpath, buildpath/"src/github.com/spf13/hugo"
    Language::Go.stage_deps resources, buildpath/"src"

    system "go", "build", "-o", bin/"hugo", "main.go"

    # Build bash completion
    system bin/"hugo", "gen", "autocomplete", "--completionfile=#{buildpath}/hugo.sh"
    bash_completion.install "hugo.sh"

    # Build man pages; target dir man/ is hardcoded :(
    mkdir_p buildpath/"man/"
    system bin/"hugo", "gen", "man"
    man1.install Dir["man/*.1"]
  end

  test do
    site = testpath/"hops-yeast-malt-water"
    system "#{bin}/hugo", "new", "site", site
    assert File.exist?("#{site}/config.toml")
  end
end
