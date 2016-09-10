require "language/go"

class Gron < Formula
  desc "Make JSON greppable"
  homepage "https://github.com/tomnomnom/gron"
  url "https://github.com/tomnomnom/gron/archive/v0.3.4.tar.gz"
  sha256 "a7e5089b9cef7140eab50effbc97a72a2dd65321f83f2a7624dbdcab3378fbb7"

  head "https://github.com/tomnomnom/gron.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "bc83a27e78f0ff583050e3275da408c18e36d5f8bab6ebed15056a7bc43d5771" => :el_capitan
    sha256 "8ab4bfffdf4ee8f2b200a7f213899362563014498a0dc2891939de7ba8d7b912" => :yosemite
    sha256 "0e71f269dcbb6d26d60657d853087d34eaf688eaf8dad703b5d7d142cc5753b0" => :mavericks
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
    mkdir_p buildpath/"src/github.com/tomnomnom/"
    ln_s buildpath, buildpath/"src/github.com/tomnomnom/gron"
    ENV["GOPATH"] = buildpath
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
