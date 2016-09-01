require "language/go"

class Gron < Formula
  desc "Make JSON greppable"
  homepage "https://github.com/tomnomnom/gron"
  url "https://github.com/tomnomnom/gron/archive/v0.3.2.tar.gz"
  sha256 "e93b31a2cd9c0b1404bad4f796e5df88f943585824f084b181ef0898f77b8da7"

  head "https://github.com/tomnomnom/gron.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "9fd296a377a1eb6068048bc21d052a909d63f6590c47e885e661304ba28789ed" => :el_capitan
    sha256 "1991ed00dd8190d9e91e4d4c8ae9475ce9483938ba112fb1f1a38ad5ed237330" => :yosemite
    sha256 "c4ba3c1466673fdfae3a93d4bc9e4008a6146dcef13c6fbdbf8e3a67dce6cf65" => :mavericks
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
