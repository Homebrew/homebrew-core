require "language/go"

class Deis < Formula
  desc "The CLI for Deis Workflow"
  homepage "https://deis.io/"
  url "https://github.com/deis/workflow-cli/archive/v2.11.0.tar.gz"
  sha256 "e35744bd5223d9099f719c69fc1eda648c44075cd29014dd82da5a2a141f3382"

  bottle do
    cellar :any_skip_relocation
    sha256 "6dea556ef879ceab2740f8cca4c2a41795e1b4bdb1e32c8b84112db7b3945949" => :sierra
    sha256 "68dafd171f6f48bb07be6fbcf0a5d751e1844ca3bd1a433126588360f3caa902" => :el_capitan
    sha256 "24482a9d0a0bdc44da340b9f368a4a1b40aab561a5dd33522d29e1979365f812" => :yosemite
  end

  depends_on "go" => :build

  go_resource "github.com/deis/pkg" do
    url "https://github.com/deis/pkg.git",
        :revision => "28bd07fbcbec5aaaaeda05d362d8ff81f55f4f6c"
  end

  go_resource "github.com/deis/controller-sdk-go" do
    url "https://github.com/deis/controller-sdk-go.git",
        :revision => "9520b6c460202f376856d042ac4864ee951cdf3a"
  end

  go_resource "github.com/goware/urlx" do
    url "https://github.com/goware/urlx.git",
        :revision => "8bb4a2e4339f55b15164907177e96e9faf885504"
  end

  go_resource "github.com/PuerkitoBio/purell" do
    url "https://github.com/PuerkitoBio/purell.git",
        :revision => "0bcb03f4b4d0a9428594752bd2a3b9aa0a9d4bd4"
  end

  go_resource "github.com/PuerkitoBio/urlesc" do
    url "https://github.com/PuerkitoBio/urlesc.git",
        :revision => "5bd2802263f21d8788851d5305584c82a5c75d7e"
  end

  go_resource "golang.org/x/text" do
    url "https://github.com/golang/text.git",
        :revision => "85c29909967d7f171f821e7a42e7b7af76fb9598"
  end

  go_resource "golang.org/x/net" do
    url "https://github.com/golang/net.git",
        :revision => "b4690f45fa1cafc47b1c280c2e75116efe40cc13"
  end

  go_resource "github.com/docopt/docopt-go" do
    url "https://github.com/docopt/docopt.go.git",
        :revision => "784ddc588536785e7299f7272f39101f7faccc3f"
  end

  go_resource "github.com/olekukonko/tablewriter" do
    url "https://github.com/olekukonko/tablewriter.git",
        :revision => "febf2d34b54a69ce7530036c7503b1c9fbfdf0bb"
  end

  go_resource "github.com/mattn/go-runewidth" do
    url "https://github.com/mattn/go-runewidth.git",
        :revision => "14207d285c6c197daabb5c9793d63e7af9ab2d50"
  end

  go_resource "golang.org/x/crypto" do
    url "https://github.com/golang/crypto.git",
        :revision => "453249f01cfeb54c3d549ddb75ff152ca243f9d8"
  end

  go_resource "gopkg.in/yaml.v2" do
    url "https://github.com/go-yaml/yaml.git",
        :revision => "a3f3340b5840cee44f372bddb5880fcbc419b46a"
  end

  def install
    ENV["GOPATH"] = buildpath
    deispath = buildpath/"src/github.com/deis/workflow-cli"
    deispath.install Dir["{*,.git}"]
    Language::Go.stage_deps resources, buildpath/"src"

    cd "src/github.com/deis/workflow-cli" do
      system "go", "build", "-o", "build/deis",
        "-ldflags",
        "'-X=github.com/deis/workflow-cli/version.Version=v2.11.0'"
      bin.install "build/deis"
    end
  end

  test do
    system bin/"deis", "logout"
  end
end
