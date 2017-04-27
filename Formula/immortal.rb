class Immortal < Formula
  desc "OS agnostic (*nix) cross-platform supervisor"
  homepage "https://immortal.run/"
  url "https://github.com/immortal/immortal/archive/0.13.2.tar.gz"
  sha256 "f34674720828c984ef34df33b75b614fabe81e4fd50eb152746a33a273daa4f9"
  head "https://github.com/immortal/immortal.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "33f246592883862a31fead5edd112a6b599df2bf1ddcf4025bc1c57e0163cac8" => :sierra
    sha256 "339e8a2d41554c8fa0df6d6c6c9dc05f4e1635fc492415e529865b271d29297e" => :el_capitan
    sha256 "62bf96158973768f1e2ebc4ce476b370f9c421ab65ded7346a7203b901133223" => :yosemite
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/immortal/immortal").install buildpath.children
    cd "src/github.com/immortal/immortal" do
      system "make", "install", "DESTDIR=#{prefix}"
    end
  end

  test do
    system bin/"immortal", "-v"
    system bin/"immortalctl", "-v"
    system bin/"immortaldir", "-v"
  end
end
