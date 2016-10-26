require "language/go"

class Micro < Formula
  desc "Modern and intuitive terminal-based text editor"
  homepage "https://github.com/zyedidia/micro"
  url "https://github.com/zyedidia/micro.git",
    :tag => "v1.1.2",
    :revision => "c04a4ba6045058190072543e644a022aa7aa3956"
  head "https://github.com/zyedidia/micro.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "425950488616512d24cc8bb172e3d08e7fb41d6ca7f451a9d6ba1378fc225bdc" => :sierra
    sha256 "d1462043d32fd76f3dfcb12106c5a08dd6da2b67183e8e8d853bda4094a9d5fc" => :el_capitan
    sha256 "c3dd62fbb9c447e962dbf38b5af8ea9621a1e1d9c2d7c46784909ec373395e2a" => :yosemite
  end

  depends_on "go" => :build

  go_resource "github.com/blang/semver" do
    url "https://github.com/blang/semver.git",
        :revision => "60ec3488bfea7cca02b021d106d9911120d25fe9"
  end

  go_resource "github.com/gdamore/encoding" do
    url "https://github.com/gdamore/encoding.git",
        :revision => "b23993cbb6353f0e6aa98d0ee318a34728f628b9"
  end

  go_resource "github.com/go-errors/errors" do
    url "https://github.com/go-errors/errors.git",
        :revision => "a41850380601eeb43f4350f7d17c6bbd8944aaf8"
  end

  go_resource "github.com/layeh/gopher-luar" do
    url "https://github.com/layeh/gopher-luar.git",
        :revision => "921d03e21a7844141b02d4c729269b6709762f28"
  end

  go_resource "github.com/lucasb-eyer/go-colorful" do
    url "https://github.com/lucasb-eyer/go-colorful.git",
        :revision => "9c2852a141bf4711e4276f8f119c90d0f20a556c"
  end

  go_resource "github.com/mattn/go-isatty" do
    url "https://github.com/mattn/go-isatty.git",
        :revision => "66b8e73f3f5cda9f96b69efd03dd3d7fc4a5cdb8"
  end

  go_resource "github.com/mattn/go-runewidth" do
    url "https://github.com/mattn/go-runewidth.git",
        :revision => "737072b4e32b7a5018b4a7125da8d12de90e8045"
  end

  go_resource "github.com/mitchellh/go-homedir" do
    url "https://github.com/mitchellh/go-homedir.git",
        :revision => "756f7b183b7ab78acdbbee5c7f392838ed459dda"
  end

  go_resource "github.com/sergi/go-diff" do
    url "https://github.com/sergi/go-diff.git",
        :revision => "1d28411638c1e67fe1930830df207bef72496ae9"
  end

  go_resource "github.com/yuin/gopher-lua" do
    url "https://github.com/yuin/gopher-lua.git",
        :revision => "d0d5dd3565a9f3c86ff5bc42a0b1cc9e5bfcf55e"
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
        :revision => "5a42fa2464759cbb7ee0af9de00b54d69f09a29c"
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
