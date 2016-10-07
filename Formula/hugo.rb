require "language/go"

class Hugo < Formula
  desc "Configurable static site generator"
  homepage "https://gohugo.io/"
  url "https://github.com/spf13/hugo/archive/v0.17.tar.gz"
  sha256 "c09913e00d8af9d7ffc7a6aa414c147f8edd7417d430fd59478989e544347590"
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
        :revision => "99064174e013895bbd9b025c31100bd1d9b590ca"
  end

  go_resource "github.com/PuerkitoBio/purell" do
    url "https://github.com/PuerkitoBio/purell.git",
        :revision => "8a290539e2e8629dbc4e6bad948158f790ec31f4"
  end

  go_resource "github.com/PuerkitoBio/urlesc" do
    url "https://github.com/PuerkitoBio/urlesc.git",
        :revision => "5bd2802263f21d8788851d5305584c82a5c75d7e"
  end

  go_resource "github.com/bep/inflect" do
    url "https://github.com/bep/inflect.git",
        :revision => "b896c45f5af983b1f416bdf3bb89c4f1f0926f69"
  end

  go_resource "github.com/cpuguy83/go-md2man" do
    url "https://github.com/cpuguy83/go-md2man.git",
        :revision => "a65d4d2de4d5f7c74868dfa9b202a3c8be315aaa"
  end

  go_resource "github.com/dchest/cssmin" do
    url "https://github.com/dchest/cssmin.git",
        :revision => "fb8d9b44afdc258bfff6052d3667521babcb2239"
  end

  go_resource "github.com/eknkc/amber" do
    url "https://github.com/eknkc/amber.git",
        :revision => "7875e9689d335cd15294cd6f4f0ef8322ce4c8e7"
  end

  go_resource "github.com/fsnotify/fsnotify" do
    url "https://github.com/fsnotify/fsnotify.git",
        :revision => "f12c6236fe7b5cf6bcf30e5935d08cb079d78334"
  end

  go_resource "github.com/gorilla/websocket" do
    url "https://github.com/gorilla/websocket.git",
        :revision => "2d1e4548da234d9cb742cc3628556fef86aafbac"
  end

  go_resource "github.com/hashicorp/hcl" do
    url "https://github.com/hashicorp/hcl.git",
        :revision => "ef8133da8cda503718a74741312bf50821e6de79"
  end

  go_resource "github.com/inconshreveable/mousetrap" do
    url "github.com/inconshreveable/mousetrap.git",
        :revision => "76626ae9c91c4f2a10f34cad8ce83ea42c93bb75"
  end

  go_resource "github.com/kardianos/osext" do
    url "https://github.com/kardianos/osext.git",
        :revision => "c2c54e542fb797ad986b31721e1baedf214ca413"
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
        :revision => "0723e352fa358f9322c938cc2dadda874e9151a9"
  end

  go_resource "github.com/miekg/mmark" do
    url "https://github.com/miekg/mmark.git",
        :revision => "78d9f44038b26a921d5bfa9a013cd74e1c2c83b6"
  end

  go_resource "github.com/mitchellh/mapstructure" do
    url "https://github.com/mitchellh/mapstructure.git",
        :revision => "ca63d7c062ee3c9f34db231e352b60012b4fd0c1"
  end

  go_resource "github.com/nicksnyder/go-i18n" do
    url "https://github.com/nicksnyder/go-i18n.git",
        :revision => "37e5c2de3e03e4b82693e3fcb4a6aa2cc4eb07e3"
  end

  go_resource "github.com/opennota/urlesc" do
    url "https://github.com/opennota/urlesc.git",
        :revision => "5bd2802263f21d8788851d5305584c82a5c75d7e"
  end

  go_resource "github.com/pelletier/go-buffruneio" do
    url "https://github.com/pelletier/go-buffruneio.git",
        :revision => "df1e16fde7fc330a0ca68167c23bf7ed6ac31d6d"
  end

  go_resource "github.com/pelletier/go-toml" do
    url "https://github.com/pelletier/go-toml.git",
        :revision => "45932ad32dfdd20826f5671da37a5f3ce9f26a8d"
  end

  go_resource "github.com/pkg/errors" do
    url "https://github.com/pkg/errors.git",
        :revision => "a887431f7f6ef7687b556dbf718d9f351d4858a0"
  end

  go_resource "github.com/pkg/sftp" do
    url "https://github.com/pkg/sftp.git",
        :revision => "8197a2e580736b78d704be0fc47b2324c0591a32"
  end

  go_resource "github.com/russross/blackfriday" do
    url "https://github.com/russross/blackfriday.git",
        :revision => "35eb537633d9950afc8ae7bdf0edb6134584e9fc"
  end

  go_resource "github.com/shurcooL/sanitized_anchor_name" do
    url "https://github.com/shurcooL/sanitized_anchor_name.git",
        :revision => "1dba4b3954bc059efc3991ec364f9f9a35f597d2"
  end

  go_resource "github.com/spf13/afero" do
    url "https://github.com/spf13/afero.git",
        :revision => "52e4a6cfac46163658bd4f123c49b6ee7dc75f78"
  end

  go_resource "github.com/spf13/cast" do
    url "https://github.com/spf13/cast.git",
        :revision => "2580bc98dc0e62908119e4737030cc2fdfc45e4c"
  end

  go_resource "github.com/spf13/cobra" do
    url "https://github.com/spf13/cobra.git",
        :revision => "9c28e4bbd74e5c3ed7aacbc552b2cab7cfdfe744"
  end

  go_resource "github.com/spf13/fsync" do
    url "https://github.com/spf13/fsync.git",
        :revision => "1773df7b269b572f0fc8df916b38e3c9d15cee66"
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
        :revision => "c7e63cf4530bcd3ba943729cee0efeff2ebea63f"
  end

  go_resource "github.com/spf13/viper" do
    url "https://github.com/spf13/viper.git",
        :revision => "670c42a85b2a2215949acd943cb8f11add317e3f"
  end

  go_resource "github.com/stretchr/testify" do
    url "https://github.com/stretchr/testify.git",
        :revision => "d77da356e56a7428ad25149ca77381849a6a5232"
  end

  go_resource "github.com/yosssi/ace" do
    url "https://github.com/yosssi/ace.git",
        :revision => "ea038f4770b6746c3f8f84f14fa60d9fe1205b56"
  end

  go_resource "golang.org/x/crypto" do
    url "https://go.googlesource.com/crypto.git",
        :revision => "81372b2fc2f10bef2a7f338da115c315a56b2726"
  end

  go_resource "golang.org/x/net" do
    url "https://go.googlesource.com/net.git",
        :revision => "71a035914f99bb58fe82eac0f1289f10963d876c"
  end

  go_resource "golang.org/x/sys" do
    url "https://go.googlesource.com/sys.git",
        :revision => "8f0908ab3b2457e2e15403d3697c9ef5cb4b57a9"
  end

  go_resource "golang.org/x/text" do
    url "https://go.googlesource.com/text.git",
        :revision => "04b8648d973c126ae60143b3e1473bc1576c7597"
  end

  go_resource "gopkg.in/yaml.v2" do
    url "https://gopkg.in/yaml.v2.git",
        :revision => "31c299268d302dd0aa9a0dcf765a3d58971ac83f"
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
