class Iperf3 < Formula
  desc "Update of iperf: measures TCP, UDP, and SCTP bandwidth"
  homepage "https://github.com/esnet/iperf"
  url "https://github.com/esnet/iperf/archive/3.2.tar.gz"
  sha256 "cb20d3a33e07a3b45a49a358b044f4998f452ef9d1a8a5cbde476b6ab9e9b526"

  bottle do
    cellar :any
    sha256 "82230c9cf186de71172461122b101fa622cef3457cb0d5283a71c46f2cc80f9f" => :sierra
    sha256 "a16d98e79ce27913beeba19eefde5db570f826f17fbc9ad73350e7ac100efba2" => :el_capitan
    sha256 "7d9c893cd29d3927200332817c6e7b99b0b263ba8f8066b7f2f4c2828c4b278e" => :yosemite
  end

  head do
    url "https://github.com/esnet/iperf.git"

    depends_on "libtool" => :build
    depends_on "automake" => :build
    depends_on "autoconf" => :build
  end

  depends_on "openssl"

  def install
    system "./bootstrap.sh" if build.head?
    system "./configure", "--prefix=#{prefix}",
                          "--with-openssl=#{Formula["openssl"].opt_prefix}"
    system "make", "clean" # there are pre-compiled files in the tarball
    system "make", "install"
  end

  test do
    system bin/"iperf3", "--version"
  end
end
