require "language/go"

class Goad < Formula
  desc "AWS Lambda powered, highly distributed, load testing tool built in Go"
  homepage "https://goad.io/"
  url "https://github.com/goadapp/goad.git",
      :tag => "v1.4.1",
      :revision => "6cd24daf34c487894e7008e080c017989d03db4a"

  bottle do
    cellar :any_skip_relocation
    sha256 "d1fb82dbc708716ae26f8d5b80bd56d727852c2045089c8830fd479ea2e66df1" => :sierra
    sha256 "a7bca02de108e120aa1ab0e2dd83c1d2d1f665a4181cc577fc9c694442af1398" => :el_capitan
    sha256 "dacd6c9ea183a71031cdad3506d76b836d77dc3eae5470388a1cf2bd7b662883" => :yosemite
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
