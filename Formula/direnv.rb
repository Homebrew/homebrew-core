class Direnv < Formula
  desc "Load/unload environment variables based on $PWD"
  homepage "https://direnv.net/"
  url "https://github.com/direnv/direnv/archive/v2.13.3.tar.gz"
  sha256 "2d5569ef08a919e02d8b229b8f71ca01a0f3920e7e14f0b10c0df76bb4ea57a1"
  head "https://github.com/direnv/direnv.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "246785d00c6d5cce2e0a21d8b6dda4ac0497414de11b1d0d4089ee185b98fca2" => :high_sierra
    sha256 "fcf790131bba61afc0fdeccc82d6612e7b44d9d92583babacdc31158cf62e360" => :sierra
    sha256 "21a3cc6a14c9bae0bd5cd83cefa27269027c9d891453217e840d43ff5c0b1c5b" => :el_capitan
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
