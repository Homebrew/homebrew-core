class Direnv < Formula
  desc "Load/unload environment variables based on $PWD"
  homepage "https://direnv.net/"
  url "https://github.com/direnv/direnv/archive/v2.20.1.tar.gz"
  sha256 "dd54393661602bb989ee880f14c41f7a7b47a153777999509127459edae52e47"
  head "https://github.com/direnv/direnv.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "c541d7006ebf393499c5f101e47ebd104a94dab0231d691ab57e04374a3a8b65" => :mojave
    sha256 "6fb07738873ad164a2166e4c378ad6fa79aa7891bce677752eb4b893b46fe4eb" => :high_sierra
    sha256 "83a9d8c4cbd6a6956587554c25eb59666c6ce786e68302be00818434796ca796" => :sierra
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
