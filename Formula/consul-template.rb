require "language/go"

class ConsulTemplate < Formula
  desc "Generic template rendering and notifications with Consul"
  homepage "https://github.com/hashicorp/consul-template"
  url "https://github.com/hashicorp/consul-template.git",
      :tag => "v0.14.0",
      :revision => "de567d675358c7b65d8db735bf8747215c90bd46"

  head "https://github.com/hashicorp/consul-template.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "d443e8a8f8c27305217b5a55d2727440a1130997e352c168c9e2c9d039f79561" => :el_capitan
    sha256 "fb0e8fec030773567533e05b6e5896fcd00b036a3ae2024718e5c18a0ee0c0c6" => :yosemite
    sha256 "4581aced5715904a34cb6b4619465181c6707850888bd49e09ab3debe02a578a" => :mavericks
  end

  depends_on "go" => :build

  go_resource "github.com/mitchellh/gox" do
    url "https://github.com/mitchellh/gox.git",
      :revision => "54b619477e8932bbb6314644c867e7e6db7a9c71"
  end

  go_resource "github.com/fatih/structs" do
    url "https://github.com/fatih/structs.git",
      :revision => "73c4e3dc02a78deaba8640d5f3a8c236ec1352bf"
  end

  go_resource "github.com/hashicorp/consul" do
    url "https://github.com/hashicorp/consul.git",
      :revision => "26a0ef8c41aa2252ab4cf0844fc6470c8e1d8256"
  end

  go_resource "github.com/hashicorp/errwrap" do
    url "https://github.com/hashicorp/errwrap.git",
      :revision => "7554cd9344cec97297fa6649b055a8c98c2a1e55"
  end

  go_resource "github.com/hashicorp/go-cleanhttp" do
    url "https://github.com/hashicorp/go-cleanhttp.git",
      :revision => "ad28ea4487f05916463e2423a55166280e8254b5"
  end

  go_resource "github.com/hashicorp/go-multierror" do
    url "https://github.com/hashicorp/go-multierror.git",
      :revision => "d30f09973e19c1dfcd120b2d9c4f168e68d6b5d5"
  end

  go_resource "github.com/hashicorp/go-reap" do
    url "https://github.com/hashicorp/go-reap.git",
      :revision => "2d85522212dcf5a84c6b357094f5c44710441912"
  end

  go_resource "github.com/hashicorp/go-syslog" do
    url "https://github.com/hashicorp/go-syslog.git",
      :revision => "42a2b573b664dbf281bd48c3cc12c086b17a39ba"
  end

  go_resource "github.com/hashicorp/hcl" do
    url "https://github.com/hashicorp/hcl.git",
      :revision => "2604f3bda7e8960c1be1063709e7d7f0765048d0"
  end

  go_resource "github.com/hashicorp/logutils" do
    url "https://github.com/hashicorp/logutils.git",
      :revision => "0dc08b1671f34c4250ce212759ebd880f743d883"
  end

  go_resource "github.com/hashicorp/serf" do
    url "https://github.com/hashicorp/serf.git",
      :revision => "0df3e3df1703f838243a7f3f12bf0b88566ade5a"
  end

  go_resource "github.com/hashicorp/vault" do
    url "https://github.com/hashicorp/vault.git",
      :revision => "77f2b8a2fa408e0fc77ed7402d51cf0cfa0335d7"
  end

  go_resource "github.com/mitchellh/mapstructure" do
    url "https://github.com/mitchellh/mapstructure.git",
      :revision => "d2dd0262208475919e1a362f675cfc0e7c10e905"
  end

  go_resource "golang.org/x/sys" do
    url "https://go.googlesource.com/sys.git",
      :revision => "9eef40adf05b951699605195b829612bd7b69952"
  end

  go_resource "gopkg.in/yaml.v2" do
    url "https://gopkg.in/yaml.v2.git",
      :revision => "a83829b6f1293c91addabc89d0571c246397bbf4"
  end

  go_resource "github.com/mitchellh/iochan" do
    url "https://github.com/mitchellh/iochan.git",
      :revision => "87b45ffd0e9581375c491fef3d32130bb15c5bd7"
  end

  def install
    arch = MacOS.prefer_64_bit? ? "amd64" : "386"
    revision = `git rev-parse HEAD`
    ENV["GOPATH"] = buildpath
    # For the gox buildtool used by consul-template, which doesn't need to
    # get installed permanently
    ENV.append_path "PATH", buildpath
    contents = Dir["{*,.git,.gitignore}"]
    gopath = buildpath/"gopath"
    (gopath/"src/github.com/hashicorp/consul-template").install contents

    ENV["GOPATH"] = gopath
    ENV.prepend_create_path "PATH", gopath/"bin"

    Language::Go.stage_deps resources, gopath/"src"
    mkdir_p buildpath/"bin"

    cd gopath/"src/github.com/mitchellh/gox" do
      system "go", "build"
      buildpath.install "gox"
    end

    cd gopath/"src/github.com/hashicorp/consul-template" do
      system "gox",
             "-os=darwin",
             "-arch=#{arch}",
             "-ldflags",
             "-X main.GitCommit #{revision}",
             "-output",
             "consul-template",
             "."
      bin.install "consul-template"
    end
  end

  test do
    (testpath/"test-template").write <<-EOS.undent
      {{"homebrew" | toTitle}}
    EOS
    system "#{bin}/consul-template", "-once", \
           "-template", "test-template:test-result"
    assert_equal "Homebrew\n", (testpath/"test-result").read
  end
end
