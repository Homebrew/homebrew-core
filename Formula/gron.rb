require "language/go"

class Gron < Formula
  desc "Make JSON greppable"
  homepage "https://github.com/tomnomnom/gron"
  url "https://github.com/tomnomnom/gron/archive/v0.3.6.tar.gz"
  sha256 "b627efa5bcc6157386a5732aad6a0cc890342dc4c662e837b6d62fd527a4d5f4"
  head "https://github.com/tomnomnom/gron.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "a1e6ec699645a6a129044bc0be623869ec6473fad86733c3a693ba311c1fabb9" => :sierra
    sha256 "5dabf7c846ad10c9a1c1af80ee6dad53483bf5422503a4dc6357d9d9b73dec3a" => :el_capitan
    sha256 "9f7370ec6972aeab61929c5cf226a96b7c6059a37079ed28fd2858f1bd68ef7d" => :yosemite
    sha256 "72c982d9f74f78651f6b95e7c6ea7ecd765c6667661d9f481fd0a86984439f3d" => :mavericks
  end

  depends_on "go" => :build

  go_resource "github.com/fatih/color" do
    url "https://github.com/fatih/color.git",
        :revision => "87d4004f2ab62d0d255e0a38f1680aa534549fe3"
  end

  go_resource "github.com/mattn/go-colorable" do
    url "https://github.com/mattn/go-colorable.git",
        :revision => "ed8eb9e318d7a84ce5915b495b7d35e0cfe7b5a8"
  end

  go_resource "github.com/mattn/go-isatty" do
    url "https://github.com/mattn/go-isatty.git",
        :revision => "3a115632dcd687f9c8cd01679c83a06a0e21c1f3"
  end

  go_resource "github.com/nwidger/jsoncolor" do
    url "https://github.com/nwidger/jsoncolor.git",
        :revision => "f344a1ffbe51794516e9cf2c4d58b203863d3070"
  end

  go_resource "github.com/pkg/errors" do
    url "https://github.com/pkg/errors.git",
        :revision => "17b591df37844cde689f4d5813e5cea0927d8dd2"
  end

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/tomnomnom").mkpath
    ln_s buildpath, buildpath/"src/github.com/tomnomnom/gron"
    Language::Go.stage_deps resources, buildpath/"src"
    system "go", "build", "-o", bin/"gron"
  end

  test do
    assert_equal <<-EOS.undent, pipe_output("#{bin}/gron", "{\"foo\":1, \"bar\":2}")
      json = {};
      json.bar = 2;
      json.foo = 1;
    EOS
  end
end
