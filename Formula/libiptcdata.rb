class Libiptcdata < Formula
  desc "Virtual package provided by libiptcdata0"
  homepage "https://libiptcdata.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/libiptcdata/libiptcdata/1.0.4/libiptcdata-1.0.4.tar.gz"
  sha256 "79f63b8ce71ee45cefd34efbb66e39a22101443f4060809b8fc29c5eebdcee0e"
  license "LGPL-2.0-only"
  revision 1

  bottle do
    sha256 arm64_ventura:  "5543254a38d990ac3eabb48f51dda1eacd65fbea211200d825063385affcc014"
    sha256 arm64_monterey: "479e59e0cffe5a692546ef0bee8552cdbd43fdf6353c5c04721e92372d92f671"
    sha256 arm64_big_sur:  "45d61d51cb3e5607763ed374d5cc88e4a7c6dc8b1ba08ccd276c3379a20646bf"
    sha256 ventura:        "66ab47a907199d944b1af5b10efdd6a90b255a35395cdb69ac637253648d9d20"
    sha256 monterey:       "e93e2ffd79bb784e528ed8f8b197b808090f3cc0b653da0cc880f88db984094f"
    sha256 big_sur:        "5bb2bce1d8a877c84abb51f3b9d9e0c40588bdeb2d6ea8d66c6de230d2e35e8d"
    sha256 catalina:       "1dbcf1dd89b05f7f1fdc1a15d9c56b7e726f7296d8096ccae22fed9adf36790a"
    sha256 mojave:         "78dc7bb6b1e5bcccc1c0c9ef158b8d423f782aa455b1b10c3eebb29de6e7fa58"
    sha256 high_sierra:    "62f4a032075fbf0b9a43ef474b784bae7c47d503483bdc2e09e851c5568345e3"
    sha256 sierra:         "0a9cd6e750e496cd4eb9797ac34d3659c8dc2bb6977020def1edb2ee60711a39"
    sha256 x86_64_linux:   "4e929a2391eb2733d481f84b82cc925a1d0cf943bed4f99af876f4240b62c9c0"
  end

  depends_on "gettext"

  def install
    # Fix flat namespace usage
    inreplace "configure", "${wl}-flat_namespace ${wl}-undefined ${wl}suppress", "${wl}-undefined ${wl}dynamic_lookup"

    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
