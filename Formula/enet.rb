class Enet < Formula
  desc "Provides a network communication layer on top of UDP"
  homepage "http://enet.bespin.org"
  url "http://enet.bespin.org/download/enet-1.3.15.tar.gz"
  sha256 "5abdf63346e54272344d8184b5a2f333d202d809d28123911cbd993e5772bdfb"
  license "MIT"

  bottle do
    cellar :any
    sha256 "7188260137953334ee61ed7eb2252d813e3cb7d86985d0d18ed3e1ce84bc965f" => :catalina
    sha256 "34bc8c1bbc9d71e2af3ec8f65dd24d681ad70be68f67534bba9a40f6e68bf21e" => :mojave
    sha256 "95634a66c99f7cb4f2b4a402017fee5f2ab1f6cb36f2fe75725c44c36908bf1b" => :high_sierra
  end

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make", "install"
  end
end
