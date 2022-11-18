class Minicom < Formula
  desc "Menu-driven communications program"
  homepage "https://packages.debian.org/sid/minicom"
  url "https://deb.debian.org/debian/pool/main/m/minicom/minicom_2.8.orig.tar.bz2"
  sha256 "38cea30913a20349326ff3f1763ee1512b7b41601c24f065f365e18e9db0beba"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://deb.debian.org/debian/pool/main/m/minicom/"
    regex(/href=.*?minicom[._-]v?(\d+(?:\.\d+)+)\.orig\.t/i)
  end

  bottle do
    sha256 arm64_ventura:  "2846c9012370f9e0d674adddb25fb5ade25175bc3c09f4e3e5c458ff958bf58c"
    sha256 arm64_monterey: "12256c7a67eeb793ee71b419a2319c80038bf20b24a583a9f09ba36dc9c5b75e"
    sha256 arm64_big_sur:  "396aa4bed62d6a9162d061ff1b97a1c5fe25e5a890141d4f39c1849564e3521f"
    sha256 ventura:        "e54b71e10799dd92bd3bf337a9a0ccab6d6fc6b3f93b119652dc05b48bad0fda"
    sha256 monterey:       "e0b91adbcbaa88015cc339c7a9cd9b7f02c155b392229a93ece0baf48d798cff"
    sha256 big_sur:        "ac0a7c58888a3eeb78bbc24d8a47fa707d7e3761c4b28f46527434d49e254b55"
    sha256 catalina:       "9cee8e5839a3e19aa732307ee70246b1567ddc3a643ef39aa91b6d888301f6e5"
    sha256 mojave:         "e2b702dec206101120ce947ca2a999c9f5fe7e8c62f95b65091146b865acb268"
    sha256 x86_64_linux:   "7d1b0aae1f169968d42e4dea644dff5a4f18010b59b334439aa2bd276c6e913a"
  end

  head do
    url "https://salsa.debian.org/minicom-team/minicom.git", branch: "master"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  uses_from_macos "ncurses"

  def install
    # There is a silly bug in the Makefile where it forgets to link to iconv. Workaround below.
    ENV["LIBS"] = "-liconv" if OS.mac?

    system "./autogen.sh" if build.head?
    system "./configure", *std_configure_args, "--mandir=#{man}"
    system "make", "install"

    (prefix/"etc").mkdir
    (prefix/"var").mkdir
    (prefix/"etc/minirc.dfl").write "pu lock #{prefix}/var\npu escape-key Escape (Meta)\n"
  end

  def caveats
    <<~EOS
      Terminal Compatibility
      ======================
      If minicom doesn't see the LANG variable, it will try to fallback to
      make the layout more compatible, but uglier. Certain unsupported
      encodings will completely render the UI useless, so if the UI looks
      strange, try setting the following environment variable:

        LANG="en_US.UTF-8"

      Text Input Not Working
      ======================
      Most development boards require Serial port setup -> Hardware Flow
      Control to be set to "No" to input text.
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/minicom -v", 1)
  end
end
