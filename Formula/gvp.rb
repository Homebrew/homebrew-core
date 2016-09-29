class Gvp < Formula
  desc "Go versioning packager"
  homepage "https://github.com/pote/gvp"
  url "https://github.com/pote/gvp/archive/v0.3.0.tar.gz"
  sha256 "e1fccefa76495293350d47d197352a63cae6a014d8d28ebdedb785d4304ee338"

  bottle do
    cellar :any_skip_relocation
    sha256 "2405a1e481ebfafcd4fbfdc2874feacc402b851fafdc69596d1afa120924c157" => :sierra
    sha256 "ddd00ded9d21c3ecfe23e807619d3ab1b3011bc586db0d7d4aa8d5d87e3689c6" => :el_capitan
    sha256 "5e63da6d9c8d065277491db1658fee5c53089f7dd1bf1180e5d9e7172b376cde" => :yosemite
    sha256 "afbe7d649883c750c182976a7c09035fe30f4d56b1b5859c8d214c01334874f7" => :mavericks
  end

  # Upstream fix for "syntax error near unexpected token `;'"
  patch do
    url "https://github.com/pote/gvp/commit/11c4cefd.patch"
    sha256 "59379b52fc13d79ea03de453cd58df98ad5ddd49ba3ba5d784b8bee7649e9cd7"
  end

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system bin/"gvp", "in"
    assert File.directory? ".godeps/src"
  end
end
