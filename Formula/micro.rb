require "language/go"

class Micro < Formula
  desc "Modern and intuitive terminal-based text editor"
  homepage "https://github.com/zyedidia/micro"
  url "https://github.com/zyedidia/micro.git",
    :tag => "v1.1.4",
    :revision => "5dc8fe40ca3f2d64ff2574a074ce91b92ba14c9d"
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
        :revision => "9c2852a141bf4711e4276f8f119c90d0f20a556c"
  end

  go_resource "github.com/mattn/go-isatty" do
    url "https://github.com/mattn/go-isatty.git",
        :revision => "281032e84ae07510239465db46bf442aa44b953a"
  end

  go_resource "github.com/mattn/go-runewidth" do
    url "https://github.com/mattn/go-runewidth.git",
        :revision => "14207d285c6c197daabb5c9793d63e7af9ab2d50"
  end

  go_resource "github.com/mitchellh/go-homedir" do
    url "https://github.com/mitchellh/go-homedir.git",
        :revision => "b8bc1bf767474819792c23f32d8286a45736f1c6"
  end

  go_resource "github.com/sergi/go-diff" do
    url "https://github.com/sergi/go-diff.git",
        :revision => "24e2351369ec4949b2ed0dc5c477afdd4c4034e8"
  end

  go_resource "github.com/yuin/gopher-lua" do
    url "https://github.com/yuin/gopher-lua.git",
        :revision => "99a8c34ef9c866b59dc56f3f7b627e457c7690e2"
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
        :revision => "f03d5b8b2730cb2578c427d120a5692ca54fb67b"
  end

  go_resource "golang.org/x/net" do
    url "https://go.googlesource.com/net.git",
        :revision => "a689eb3bc4b53af70390acc3cf68c9f549b6b8d6"
  end

  go_resource "golang.org/x/text" do
    url "https://go.googlesource.com/text.git",
        :revision => "06d6eba81293389cafdff7fca90d75592194b2d9"
  end

  go_resource "layeh.com/gopher-luar" do
    url "https://github.com/layeh/gopher-luar.git",
        :revision => "80196fe2abc5682963fc7a5261f5a5d77509938b"
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
