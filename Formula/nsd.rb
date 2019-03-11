class Nsd < Formula
  desc "Name server daemon"
  homepage "https://www.nlnetlabs.nl/projects/nsd/"
  url "https://www.nlnetlabs.nl/downloads/nsd/nsd-4.1.26.tar.gz"
  sha256 "9f8a41431d21034d64b9a910567b201636521b64b6a9947390bf898388dc15f4"

  bottle do
    sha256 "c6b5c0509a19d4d2fe630072bbed9ce46669b7dac87c0bf16e6faccc3655ed5c" => :mojave
    sha256 "9c34a354bef7ccd60e9ffa227ac8a815b6e05e7443ec4b11ebb540f16cea744a" => :high_sierra
    sha256 "32ce66e05477e1408616e58812ca58cd6571600e7c336521ef0a8254ab99e644" => :sierra
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
