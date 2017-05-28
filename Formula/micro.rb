require "language/go"

class Micro < Formula
  desc "Modern and intuitive terminal-based text editor"
  homepage "https://github.com/zyedidia/micro"
  url "https://github.com/zyedidia/micro.git",
    :tag => "v1.2.0",
    :revision => "be8124154b2b3e761578a186c42a18ace5a43865"
  head "https://github.com/zyedidia/micro.git", :shallow => false

  bottle do
    cellar :any_skip_relocation
    sha256 "c5bd0f727bfe078b1f315e9c4f9610c38cb02db1c57138dc78d9c0518cfa41e8" => :sierra
    sha256 "cdfd6c9521de4a47df9cf48c58736e6584892a45729adaf7357f80efe1a78144" => :el_capitan
    sha256 "db62612120d75b76719592cdb8d7cb961541db1c6d35051a1adfa36f9faeda7a" => :yosemite
  end

  depends_on "go" => :build

  go_resource "github.com/blang/semver" do
    url "https://github.com/blang/semver.git",
        :revision => "4a1e882c79dcf4ec00d2e29fac74b9c8938d5052"
  end

  go_resource "github.com/dustin/go-humanize" do
    url "https://github.com/dustin/go-humanize.git",
        :revision => "259d2a102b871d17f30e3cd9881a642961a1e486"
  end

  go_resource "github.com/gdamore/encoding" do
    url "https://github.com/gdamore/encoding.git",
        :revision => "b23993cbb6353f0e6aa98d0ee318a34728f628b9"
  end

  go_resource "github.com/go-errors/errors" do
    url "https://github.com/go-errors/errors.git",
        :revision => "8fa88b06e5974e97fbf9899a7f86a344bfd1f105"
  end

  go_resource "github.com/lucasb-eyer/go-colorful" do
    url "https://github.com/lucasb-eyer/go-colorful.git",
        :revision => "c900de9dbbc73129068f5af6a823068fc5f2308c"
  end

  go_resource "github.com/mattn/go-isatty" do
    url "https://github.com/mattn/go-isatty.git",
        :revision => "fc9e8d8ef48496124e79ae0df75490096eccf6fe"
  end

  go_resource "github.com/mattn/go-runewidth" do
    url "https://github.com/mattn/go-runewidth.git",
        :revision => "97311d9f7767e3d6f422ea06661bc2c7a19e8a5d"
  end

  go_resource "github.com/mitchellh/go-homedir" do
    url "https://github.com/mitchellh/go-homedir.git",
        :revision => "b8bc1bf767474819792c23f32d8286a45736f1c6"
  end

  go_resource "github.com/sergi/go-diff" do
    url "https://github.com/sergi/go-diff.git",
        :revision => "feef008d51ad2b3778f85d387ccf91735543008d"
  end

  go_resource "github.com/yuin/gopher-lua" do
    url "https://github.com/yuin/gopher-lua.git",
        :revision => "b402f3114ec730d8bddb074a6c137309f561aa78"
  end

  go_resource "github.com/zyedidia/clipboard" do
    url "https://github.com/zyedidia/clipboard.git",
        :revision => "adacf416cec40266b051e7bc096c52951f2725e9"
  end

  go_resource "github.com/zyedidia/glob" do
    url "https://github.com/zyedidia/glob.git",
        :revision => "dd4023a66dc351ae26e592d21cd133b5b143f3d8"
  end

  go_resource "github.com/zyedidia/json5" do
    url "https://github.com/zyedidia/json5.git",
        :revision => "2518f8beebde6814f2d30d566260480d2ded2f76"
  end

  go_resource "github.com/zyedidia/tcell" do
    url "https://github.com/zyedidia/tcell.git",
        :revision => "7095cc1c7f4173ae48314d80878e9985a0658889"
  end

  go_resource "golang.org/x/net" do
    url "https://go.googlesource.com/net.git",
        :revision => "48359f4f600b3a2d5cf657458e3f940021631a56"
  end

  go_resource "golang.org/x/text" do
    url "https://go.googlesource.com/text.git",
        :revision => "19e51611da83d6be54ddafce4a4af510cb3e9ea4"
  end

  go_resource "gopkg.in/yaml.v2" do
    url "https://gopkg.in/yaml.v2.git",
        :revision => "cd8b52f8269e0feb286dfeef29f8fe4d5b397e0b"
  end

  go_resource "layeh.com/gopher-luar" do
    url "https://github.com/layeh/gopher-luar.git",
        :revision => "16281577dff29557258daa8ca9bc9b2e05f451f2"
  end

  def install
    ENV["GOPATH"] = buildpath
    mkdir_p buildpath/"src/github.com/zyedidia"
    ln_s buildpath, buildpath/"src/github.com/zyedidia/micro"

    if build.head?
      system "make", "build-all"
    else
      Language::Go.stage_deps resources, buildpath/"src"
      system "make", "build-quick"
    end

    bin.install "micro"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/micro -version")
  end
end
