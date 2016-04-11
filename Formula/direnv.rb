class Direnv < Formula
  desc "Load/unload environment variables based on $PWD"
  homepage "http://direnv.net"
  url "https://github.com/zimbatm/direnv/archive/v2.8.1.tar.gz"
  sha256 "918194e91435bf7ebb07705ba901e822dad7a01546e29e285043c3976fee115b"

  head "https://github.com/zimbatm/direnv.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "afd4ccd90051ac5707d8aef992a71ea08489dcab4fb035862062a94cbfdbb89c" => :el_capitan
    sha256 "8fe46374f66f8540f2837ce2c493fca2e42363d1ca92b9fb56df799546393841" => :yosemite
    sha256 "cc78050444e3b8dfef12a6e7dd1cc865d8f47afb4010e5aaf7ee35ff9876c434" => :mavericks
  end

  depends_on "go" => :build

  def install
    system "make", "install", "DESTDIR=#{prefix}"
  end

  test do
    system bin/"direnv", "status"
  end
end
