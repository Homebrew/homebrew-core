require "language/go"

class Jid < Formula
  desc "Json incremental digger"
  homepage "https://github.com/simeji/jid"
  url "https://github.com/simeji/jid/archive/0.7.2.tar.gz"
  sha256 "a16932049fb617fd7490742fcd3b5f131873309a12d97adbaf41a882cd1b99d1"

  bottle do
    cellar :any_skip_relocation
    sha256 "049d37984ecbeba231d96f23caf3dda6ef50dd8a55b91a4e0d62f7975a244c1c" => :mojave
    sha256 "b6de24c980241a14be660440dc9aba403841f5cae50c5aa973bce92ebd1c2081" => :high_sierra
    sha256 "59624c107014497a6596ce33a6344c1456731a2784ffb4e92bf0075ddda16ffa" => :sierra
    sha256 "a77b38789f565878c3dd89b031693fcb35ed60404172a4fb3702b6e0f69f76e5" => :el_capitan
    sha256 "baf231928a3d2c899f3c7ebdfae167cca4b00623def455fb4eca4b0c6ecc7f71" => :yosemite
  end

  depends_on "go" => :build

  go_resource "github.com/bitly/go-simplejson" do
    url "https://github.com/bitly/go-simplejson.git",
        :revision => "aabad6e819789e569bd6aabf444c935aa9ba1e44"
  end

  go_resource "github.com/fatih/color" do
    url "https://github.com/fatih/color.git",
        :revision => "42c364ba490082e4815b5222728711b3440603eb"
  end

  go_resource "github.com/mattn/go-colorable" do
    url "https://github.com/mattn/go-colorable.git",
        :revision => "d228849504861217f796da67fae4f6e347643f15"
  end

  go_resource "github.com/mattn/go-isatty" do
    url "https://github.com/mattn/go-isatty.git",
        :revision => "30a891c33c7cde7b02a981314b4228ec99380cca"
  end

  go_resource "github.com/mattn/go-runewidth" do
    url "https://github.com/mattn/go-runewidth.git",
        :revision => "737072b4e32b7a5018b4a7125da8d12de90e8045"
  end

  go_resource "github.com/nsf/termbox-go" do
    url "https://github.com/nsf/termbox-go.git",
        :revision => "abe82ce5fb7a42fbd6784a5ceb71aff977e09ed8"
  end

  go_resource "github.com/nwidger/jsoncolor" do
    url "https://github.com/nwidger/jsoncolor.git",
        :revision => "0192e84d44af834c3a90c8a17bf670483b91ad5a"
  end

  go_resource "github.com/pkg/errors" do
    url "https://github.com/pkg/errors.git",
        :revision => "248dadf4e9068a0b3e79f02ed0a610d935de5302"
  end

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/simeji").mkpath
    ln_sf buildpath, buildpath/"src/github.com/simeji/jid"
    Language::Go.stage_deps resources, buildpath/"src"
    system "go", "build", "-o", bin/"jid", "cmd/jid/jid.go"
  end

  test do
    assert_match "jid version v#{version}", shell_output("#{bin}/jid --version")
  end
end
