class Darkstat < Formula
  desc "Network traffic analyzer"
  homepage "https://unix4lyfe.org/darkstat/"
  url "https://unix4lyfe.org/darkstat/darkstat-3.0.719.tar.bz2"
  sha256 "aeaf909585f7f43dc032a75328fdb62114e58405b06a92a13c0d3653236dedd7"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "381e67870ea4f9f980421aa6f51580eedf98a916a09de042022744de1905798e" => :catalina
    sha256 "edef4012fbd6b7626fbbf324ae92c34afcaba39f09a8ac7c7e80a3e25cef71c7" => :mojave
    sha256 "70eae96655d9872851ea02e44709155a6a9df509210fd2b49b0b72de334248f3" => :high_sierra
    sha256 "680c9a1143b9a95990d246d7ba8357baa0ec1142545252d89734d98b8046337a" => :sierra
    sha256 "4e67244fc36d17dbdbe9ae33cc38bd79d2e016eeed0139c164d323e89b15c15e" => :el_capitan
  end

  head do
    url "https://www.unix4lyfe.org/git/darkstat", :using => :git
    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  # Patch reported to upstream on 2017-10-08
  # Work around `redefinition of clockid_t` issue on 10.12 SDK or newer
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/442ce4a5/darkstat/clock_gettime.patch"
    sha256 "001b81d417a802f16c5bc4577c3b840799511a79ceedec27fc7ff1273df1018b"
  end

  def install
    system "autoreconf", "-iv" if build.head?
    system "./configure", "--disable-debug", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system sbin/"darkstat", "--verbose", "-r", test_fixtures("test.pcap")
  end
end
