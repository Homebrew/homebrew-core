class Orbit < Formula
  desc "CORBA 2.4-compliant object request broker (ORB)"
  homepage "https://projects.gnome.org/ORBit2"
  url "https://download.gnome.org/sources/ORBit2/2.14/ORBit2-2.14.19.tar.bz2"
  sha256 "55c900a905482992730f575f3eef34d50bda717c197c97c08fa5a6eafd857550"

  bottle do
    sha256 "a70cbcdfb9d4350141ed258c4f61e0b16dddbf9bc9ce2658dfad9609a4ab3b22" => :mojave
    sha256 "4d44dbf8d5a6dcfabcbf71a0f42fb0a3f961cd7beae541f3dd657789065269c2" => :high_sierra
    sha256 "a267317818996e273fdd78837bc6e18709f273a31c21ca7dae7f09d1c634637f" => :sierra
    sha256 "11bb24fb06daef1ccea017470e23e56706c24265a4f7551a14d99e4f88121781" => :el_capitan
    sha256 "adf8c93736bee9ceede9f65ae9e4d6d10529a085315ec522bfd661a7b6fcd94a" => :yosemite
    sha256 "ae04763dcb6ea680fba27e49b01235d65204cd9240a871b429095fa414fda4fb" => :mavericks
    sha256 "9f987a2d8be82cf391d2903872cfe20ce304cbc91fbe638820c41b00a3ecb4cc" => :mountain_lion
  end

  depends_on "pkg-config" => :build
  depends_on "glib"
  depends_on "libidl"

  # per MacPorts, re-enable use of deprecated glib functions
  patch :p0 do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/6b7eaf2b/orbit/patch-linc2-src-Makefile.in.diff"
    sha256 "572771ea59f841d74ac361d51f487cc3bcb2d75dacc9c20a8bd6cbbaeae8f856"
  end

  patch :p0 do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/6b7eaf2b/orbit/patch-configure.diff"
    sha256 "34d068df8fc9482cf70b291032de911f0e75a30994562d4cf56b0cc2a8e28e42"
  end

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_match /#{version}/, shell_output("#{bin}/orbit2-config --prefix --version")
  end
end
