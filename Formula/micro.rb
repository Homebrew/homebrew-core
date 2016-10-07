require "language/go"

class Micro < Formula
  desc "Modern and intuitive terminal-based text editor"
  homepage "https://github.com/zyedidia/micro"
  url "https://github.com/zyedidia/micro.git",
    :tag => "v1.1.0",
    :revision => "6acda994e4536a873d9ff70682c1ac9896154426"
  head "https://github.com/zyedidia/micro.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "2eaffb3248b83cfaa4739e6cde2a580cefd06a565d8f940fd92338792acba575" => :sierra
    sha256 "4d8e226a79103f8cfaf74b09b6daa5783f0f0353aeec8f88e04e368dd018ab8b" => :el_capitan
    sha256 "8b0883b31661526b62b2027aaf851fbbc62d99e62a04102033d4f56224c0107c" => :yosemite
    sha256 "160e6c982d092aa4533cc1e2425863eb703c1e0ef862e68a552d7f7e48381dc1" => :mavericks
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
        :revision => "d6bea18f789704b5f83375793155289da36a3c7f"
  end

  go_resource "github.com/mitchellh/go-homedir" do
    url "https://github.com/mitchellh/go-homedir.git",
        :revision => "756f7b183b7ab78acdbbee5c7f392838ed459dda"
  end

  go_resource "github.com/sergi/go-diff" do
    url "https://github.com/sergi/go-diff.git",
        :revision => "ec7fdbb58eb3e300c8595ad5ac74a5aa50019cc7"
  end

  go_resource "github.com/yuin/gopher-lua" do
    url "https://github.com/yuin/gopher-lua.git",
        :revision => "6a1397dfb6f8e7af08496129dd96f5f62c148f47"
  end

  go_resource "github.com/zyedidia/clipboard" do
    url "https://github.com/zyedidia/clipboard.git",
        :revision => "72497670a7bd47eb648153f55bea83852546abe0"
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
        :revision => "2cdfb9030fb6b921fb1c8679219f881fd0824947"
  end

  go_resource "golang.org/x/text" do
    url "https://go.googlesource.com/text.git",
        :revision => "ceefd2213ed29504fff30155163c8f59827734f3"
  end

  def install
    ENV["GOPATH"] = buildpath
    mkdir_p buildpath/"src/github.com/zyedidia"
    ln_s buildpath, buildpath/"src/github.com/zyedidia/micro"
    Language::Go.stage_deps resources, buildpath/"src"
    hash = `git rev-parse --short HEAD`.chomp
    date = `go run tools/build-date.go`.chomp
    system "go", "build", "-o", bin/"micro", "-ldflags", <<-EOS.undent, "./cmd/micro"
      -X main.Version=#{version}
      -X main.CommitHash=#{hash}
      -X 'main.CompileDate=#{date}'
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/micro -version")
  end
end
