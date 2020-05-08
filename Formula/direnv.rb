class Direnv < Formula
  desc "Load/unload environment variables based on $PWD"
  homepage "https://direnv.net/"
  url "https://github.com/direnv/direnv/archive/v2.21.3.tar.gz"
  sha256 "012651a79e47150de4a386d1c3c81a017d5ceac14f5a0c24b0596a2215cde8be"
  head "https://github.com/direnv/direnv.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "31a7b6b1f16dd3e881ec693cb83e07757500f8d4810a5ebad3ab5986f7a6ef28" => :catalina
    sha256 "6a79378f41555b964e95c093c4a693fd2252c873bae453ebb309ec148eaeac7b" => :mojave
    sha256 "e490c0f7a242c35343e2f4d108b069380a9f73b2c7656d23db1c8940e549920b" => :high_sierra
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
