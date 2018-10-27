class Nsd < Formula
  desc "Name server daemon"
  homepage "https://www.nlnetlabs.nl/projects/nsd/"
  url "https://www.nlnetlabs.nl/downloads/nsd/nsd-4.1.25.tar.gz"
  sha256 "8f5bff5abbbb03c396afd7be575806cde1217e884c189fa34445e0ca4793df7f"

  bottle do
    sha256 "e0dec26dde18a5b5f1cee25e60db7231a61f3fe7302890977569782768f93097" => :mojave
    sha256 "ef0ff89248877b6653322d3290897f885cb8d4b48d6eb248acfc8f2d06d56c47" => :high_sierra
    sha256 "762e0ca75b35d762a64149b9e9f748fdd9c3190ccad497643388b9b7f36d3a91" => :sierra
    sha256 "1e5bf01ae719b8588c92d56b59a6d8edab91671f2f38d6c2ddc128220b4d86dc" => :el_capitan
  end

  depends_on "libevent"
  depends_on "openssl"

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--sysconfdir=#{etc}",
                          "--localstatedir=#{var}",
                          "--with-libevent=#{Formula["libevent"].opt_prefix}",
                          "--with-ssl=#{Formula["openssl"].opt_prefix}"
    system "make", "install"
  end

  test do
    system "#{sbin}/nsd", "-v"
  end
end
