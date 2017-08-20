require "language/go"

class Goad < Formula
  desc "AWS Lambda powered, highly distributed, load testing tool built in Go"
  homepage "https://goad.io/"
  url "https://github.com/goadapp/goad.git",
      :tag => "2.0.3",
      :revision => "1d56f40289699a8fcb81709db7db109b8946e17c"

  bottle do
    cellar :any_skip_relocation
    sha256 "9ed1595041e435db8dfc4c90cf43e48aea463f2854665211af060885b8353818" => :sierra
    sha256 "3ba719abd7916592eb6286ae8b5b4274cecb17644bbccf8440305908459dfcc7" => :el_capitan
    sha256 "37bd1aa77d0505833517d48aac34e1c8be80312b91a098c62f8dc61bac99c5bf" => :yosemite
  end

  depends_on "go" => :build

  go_resource "github.com/jteeuwen/go-bindata" do
    url "https://github.com/jteeuwen/go-bindata.git",
        :revision => "a0ff2567cfb70903282db057e799fd826784d41d"
  end

  def install
    ENV["GOPATH"] = buildpath
    dir = buildpath/"src/github.com/goadapp/goad"
    dir.install buildpath.children
    ENV.prepend_create_path "PATH", buildpath/"bin"
    Language::Go.stage_deps resources, buildpath/"src"

    cd "src/github.com/jteeuwen/go-bindata/go-bindata" do
      system "go", "install"
    end

    cd dir do
      system "make", "build"
      bin.install "build/goad"
      prefix.install_metafiles
    end
  end

  test do
    system "#{bin}/goad", "--version"
  end
end
