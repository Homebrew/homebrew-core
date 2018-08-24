class Libmaa < Formula
  desc "Low-level data structures including hash tables, sets, lists"
  homepage "http://www.dict.org/"
  url "https://downloads.sourceforge.net/project/dict/libmaa/libmaa-1.4.2/libmaa-1.4.2.tar.gz"
  sha256 "63de331c97a40efe8b64534fee4b7b7df161645b92636572ad248b0f13abc0db"

  bottle do
    cellar :any
    sha256 "2ae8769884345cc2a05bf3f3f67e7af2135f6b8d803b5ceb65ee6b0a8311ccce" => :mojave
    sha256 "ae189018a85ecc0e5686072f7e3882d648fc3ee341374fcf82174a7dc6af1eb9" => :high_sierra
    sha256 "84345113a91bb76b150714d7e8349d855fc86f0d6073e4fa04be43f1454ac2b9" => :sierra
    sha256 "3b774421fc6a80b592605911e67cdd6cc558d2a92b9d23304eb00225e3820e50" => :el_capitan
  end

  depends_on "bmake" => :build
  depends_on "mk-configure" => :build

  def install
    # not parallel safe, errors surrounding generated arggram.c
    # https://github.com/cheusov/libmaa/issues/2
    ENV.deparallelize
    system "mkcmake", "install", "CC=#{ENV.cc}", "PREFIX=#{prefix}"
  end
end
