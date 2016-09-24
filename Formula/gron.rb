require "language/go"

class Gron < Formula
  desc "Make JSON greppable"
  homepage "https://github.com/tomnomnom/gron"
  url "https://github.com/tomnomnom/gron/archive/v0.3.7.tar.gz"
  sha256 "742a78338fe14657b4f0ef5cc4e76d948fcb7fa4005156e98f81f0fee7474717"
  head "https://github.com/tomnomnom/gron.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "2d4b6c5d7212beb402e2ca4dc9065865ebc7bd25cf864c33c9343ff39788ff8b" => :sierra
    sha256 "4d82d9c6a9f8fba7c73db1e5f7212a11f58128235676c5d6e84c0db26f2a1fba" => :el_capitan
    sha256 "4aa183c4f319472865defffa9006d96fd713f6ce14dd39a35bca6551736965df" => :yosemite
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
