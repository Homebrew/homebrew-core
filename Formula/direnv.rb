class Direnv < Formula
  desc "Load/unload environment variables based on $PWD"
  homepage "https://direnv.net/"
  url "https://github.com/direnv/direnv/archive/v2.12.0.tar.gz"
  sha256 "a86d91ba34f2e72659e0ac114fcadc22c4e813ea88a70320e5b06a2702219df1"

  head "https://github.com/direnv/direnv.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "0e6707141631791d3df417eca9f03f28f77042bbd845a309c5cf167dc0f1a0a0" => :sierra
    sha256 "f13d3d56738cfe75563f28d1d3a65ccaf6a2d21672745f86d3513ee07bde16ad" => :el_capitan
    sha256 "900405b94731cb8fd3c59f89cad6f62218d47f5f6f79c75394ead9b4a7840051" => :yosemite
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/direnv").mkpath
    ln_s buildpath, buildpath/"src/github.com/direnv/direnv"
    system "make", "install", "DESTDIR=#{prefix}"
  end

  test do
    system bin/"direnv", "status"
  end
end
