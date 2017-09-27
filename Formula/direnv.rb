class Direnv < Formula
  desc "Load/unload environment variables based on $PWD"
  homepage "https://direnv.net/"
  url "https://github.com/direnv/direnv/archive/v2.13.1.tar.gz"
  sha256 "eea1d4eb4c95c1a6d41bb05a35ed0e106d497f10761e5d0e1c3b87d07c70c7b4"
  head "https://github.com/direnv/direnv.git"

  bottle do
    cellar :any
    sha256 "ba6b8589e47a6b1c2d61f2c8cd7cfa1aaacb8876e6c0f8b38e5cc0628d8a0a49" => :high_sierra
    sha256 "33148330cfc534aae85ad52c94126e00488eb8fef433832bc770f20db7318d1a" => :sierra
    sha256 "859190f1008fc41df4c07bb7925c9dbbbab1cf7ef24248b613f941b23a4b7e02" => :el_capitan
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/direnv/direnv").install buildpath.children
    cd "src/github.com/direnv/direnv" do
      system "make", "install", "DESTDIR=#{prefix}"
      prefix.install_metafiles
    end
  end

  test do
    system bin/"direnv", "status"
  end
end
