class Camlistore < Formula
  desc "Content-addressable multi-layer indexed storage"
  homepage "https://camlistore.org"
  url "https://github.com/camlistore/camlistore.git",
      :tag => "0.9",
      :revision => "7b78c50007780643798adf3fee4c84f3a10154c9"
  head "https://camlistore.googlesource.com/camlistore", :using => :git

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "4b3f55fa627f93bce045e1512945b39f5e2b49295d4a0b6097488b2d462f7a93" => :sierra
    sha256 "6af3ede34fb4ffff477b344e8d2c974df5b714d48c51ff01606eb81743083431" => :el_capitan
    sha256 "04e30799c15004110922c231e3ae28f533d73af21c6e7f4831c6845442746169" => :yosemite
  end

  depends_on "pkg-config" => :build
  depends_on "go" => :build
  depends_on "sqlite"

  conflicts_with "hello", :because => "both install `hello` binaries"

  def install
    system "go", "run", "make.go"
    prefix.install "bin/README"
    prefix.install "bin"
  end

  test do
    system bin/"camget", "-version"
  end
end
