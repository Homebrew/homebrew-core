require "language/go"

class Micro < Formula
  desc "Modern and intuitive terminal-based text editor"
  homepage "https://github.com/zyedidia/micro"
  url "https://github.com/zyedidia/micro.git",
    :tag => "v1.1.3",
    :revision => "67ac3f1a244913273ece41fe78208de635c1d6db"
  head "https://github.com/zyedidia/micro.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "5e02a361c25d9f9943de34bd780131040829f5f36dd0ee80293cd838355ec57b" => :sierra
    sha256 "0fb1e8ec17e28deaf789edc81bf28cd6c98453109403169b24926dc5cec91015" => :el_capitan
    sha256 "420018246f2c71f7366b5a651dfe3c46bde1348d93894d38638deaac23da7cbb" => :yosemite
  end

  depends_on "go" => :build

  go_resource "github.com/blang/semver" do
    url "https://github.com/blang/semver.git",
        :revision => "3a37c301dda64cbe17f16f661b4c976803c0e2d2"
  end

  go_resource "github.com/gdamore/encoding" do
    url "https://github.com/gdamore/encoding.git",
        :revision => "b23993cbb6353f0e6aa98d0ee318a34728f628b9"
  end

  go_resource "github.com/go-errors/errors" do
    url "https://github.com/go-errors/errors.git",
        :revision => "8fa88b06e5974e97fbf9899a7f86a344bfd1f105"
  end

  go_resource "github.com/layeh/gopher-luar" do
    url "https://github.com/layeh/gopher-luar.git",
        :revision => "8d335db8d052b4757fc8891f2b27b4d6ee4a7b97"
  end

  go_resource "github.com/lucasb-eyer/go-colorful" do
    url "https://github.com/lucasb-eyer/go-colorful.git",
        :revision => "9c2852a141bf4711e4276f8f119c90d0f20a556c"
  end

  go_resource "github.com/mattn/go-isatty" do
    url "https://github.com/mattn/go-isatty.git",
        :revision => "30a891c33c7cde7b02a981314b4228ec99380cca"
  end

  go_resource "github.com/mattn/go-runewidth" do
    url "https://github.com/mattn/go-runewidth.git",
        :revision => "737072b4e32b7a5018b4a7125da8d12de90e8045"
  end

  go_resource "github.com/mitchellh/go-homedir" do
    url "https://github.com/mitchellh/go-homedir.git",
        :revision => "b8bc1bf767474819792c23f32d8286a45736f1c6"
  end

  go_resource "github.com/sergi/go-diff" do
    url "https://github.com/sergi/go-diff.git",
        :revision => "83532ca1c1caa393179c677b6facf48e61f4ca5d"
  end

  go_resource "github.com/yuin/gopher-lua" do
    url "https://github.com/yuin/gopher-lua.git",
        :revision => "7692488a1ad6bd06dc48890f4a149b65a86a767d"
  end

  go_resource "github.com/zyedidia/clipboard" do
    url "https://github.com/zyedidia/clipboard.git",
        :revision => "7b4ccc9435f89956bfa9466c3c42717df272e3bd"
  end

  go_resource "github.com/zyedidia/glob" do
    url "https://github.com/zyedidia/glob.git",
        :revision => "7cf5a078d22fc41b27fbda73685c88a3f2c6fe28"
  end

  go_resource "github.com/zyedidia/json5" do
    url "https://github.com/zyedidia/json5.git",
        :revision => "2518f8beebde6814f2d30d566260480d2ded2f76"
  end

  go_resource "github.com/zyedidia/tcell" do
    url "https://github.com/zyedidia/tcell.git",
        :revision => "f03d5b8b2730cb2578c427d120a5692ca54fb67b"
  end

  go_resource "golang.org/x/text" do
    url "https://go.googlesource.com/text.git",
        :revision => "5c6cf4f9a2357d38515014cea8c488ed22bdab90"
  end

  def install
    ENV["GOPATH"] = buildpath
    mkdir_p buildpath/"src/github.com/zyedidia"
    ln_s buildpath, buildpath/"src/github.com/zyedidia/micro"
    Language::Go.stage_deps resources, buildpath/"src"
    system "make", "build"
    bin.install "micro"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/micro -version")
  end
end
