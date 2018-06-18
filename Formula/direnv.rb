class Direnv < Formula
  desc "Load/unload environment variables based on $PWD"
  homepage "https://direnv.net/"
  url "https://github.com/direnv/direnv/archive/v2.17.0.tar.gz"
  sha256 "1402cfbd9988cfe86d0ded47bd9732a061581f04bdb6275f156d8654e4d09a3a"
  head "https://github.com/direnv/direnv.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "a340e02603e236c0c10b201d7dd519eaa4ae5608d01d5902f231d36d463092f6" => :high_sierra
    sha256 "29590b98c6e18ccdbf7e2848bcc5dadf0c740d21c2cdb774688c05ecb008f2aa" => :sierra
    sha256 "5a2d9fc4daf400cbd696e65f264a8301fd75dc1924c649805d507c5175edfc3c" => :el_capitan
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
