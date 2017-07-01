class Direnv < Formula
  desc "Load/unload environment variables based on $PWD"
  homepage "https://direnv.net/"
  url "https://github.com/direnv/direnv/archive/v2.12.1.tar.gz"
  sha256 "7ca0649add19e4ed6b5b0b0f88c9222916e700f413e535e54b8f6431a2b34797"

  head "https://github.com/direnv/direnv.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "b0d36f653cc0e2252aecc8e3a904f76b87904dad28ba21f9e59d55fbd6092034" => :sierra
    sha256 "756c5baa9222f3777b02b45a777a6f94152d6ef3d227b28fdb6b8a2563a724ad" => :el_capitan
    sha256 "090bd52ae6075356210fbfc1e75d86f5fd6993f04043ce47efe070a6f3fc2aa7" => :yosemite
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
