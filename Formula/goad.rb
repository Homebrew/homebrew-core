require "language/go"

class Goad < Formula
  desc "AWS Lambda powered, highly distributed, load testing tool built in Go"
  homepage "https://goad.io/"
  url "https://github.com/goadapp/goad.git",
      :tag => "v1.4.1",
      :revision => "6cd24daf34c487894e7008e080c017989d03db4a"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "331937d2ca071b3da60f458b1d5750b3b16defbafe795f52b44780639da38672" => :sierra
    sha256 "d7deb965c800fc18375e808f76e8a6a05419c346257b550201f079ea5c922933" => :el_capitan
    sha256 "93c7b9b8d2f3ad8ddd689bb0079478c3b5ac9c044af3cffdf1f874e526656002" => :yosemite
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
