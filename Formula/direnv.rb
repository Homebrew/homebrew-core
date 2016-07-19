class Direnv < Formula
  desc "Load/unload environment variables based on $PWD"
  homepage "http://direnv.net"
  url "https://github.com/zimbatm/direnv/archive/v2.9.0.tar.gz"
  sha256 "023d9d7e1c52596000d1f4758b2f5677eb1624d39d5ed6d7dbd1d4f4b5d86313"

  head "https://github.com/zimbatm/direnv.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "a95bf5ca6f2d723883b0f7ed3811603943d801b975513928b0fab75681c0ae64" => :el_capitan
    sha256 "8cacdbe6ccdb43e5595824b781638479e8664b231344860c75f1fc27e55a00e0" => :yosemite
    sha256 "5df957312c326778b364a4b8e0319fe934bf0d466ef9a26ed8f6adf39f62d3c6" => :mavericks
  end

  depends_on "go" => :build

  def install
    system "make", "install", "DESTDIR=#{prefix}"
  end

  test do
    system bin/"direnv", "status"
  end
end
