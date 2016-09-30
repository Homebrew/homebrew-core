class Armor < Formula
  desc "Simple HTTP server, supports HTTP/2 and auto TLS"
  homepage "https://github.com/labstack/armor"
  url "https://github.com/labstack/armor/archive/v0.1.0.tar.gz"
  sha256 "fc06d7fa1b6346dc3ab150d3eea5d85f35108cbd6b97c97ccff3e1732eb56209"
  head "https://github.com/labstack/armor.git"

  depends_on "glide"

  def install
    ENV["GOPATH"] = buildpath
    ENV["GLIDE_HOME"] = buildpath/"glide_home"
    armorpath = buildpath/"src/github.com/labstack/armor"
    armorpath.install buildpath.children

    cd armorpath do
      system "glide", "install"
      system "go", "build", "-o", bin/"armor", "cmd/armor/main.go"
    end
  end

  test do
    system "armor", "-h"
  end
end
