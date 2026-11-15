class LibcapNg < Formula
  desc "Library for Linux that makes using posix capabilities easy"
  homepage "https://people.redhat.com/sgrubb/libcap-ng/"
  url "https://github.com/stevegrubb/libcap-ng/archive/refs/tags/v0.9.6.tar.gz"
  sha256 "399040138e0ca62fa2bcabd63da9af4431a246ef7a654561a0ca3cb00010a539"
  license all_of: ["LGPL-2.1-or-later", "GPL-2.0-or-later"]
  revision 1
  compatibility_version 1
  head "https://github.com/stevegrubb/libcap-ng.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_linux:  "2046c58d9207c9007021a76c4f5f494bad73d7178eb7e3ea8fa7659848645157"
    sha256 cellar: :any, x86_64_linux: "b390648b787ce65412ab3529aca321ba19da67d75fd727f79790a6b029976dc0"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "m4" => :build
  depends_on "pkgconf" => :build
  depends_on "python-setuptools" => :build
  depends_on "python@3.15" => [:build, :test]
  depends_on "swig" => :build
  depends_on :linux

  def install
    system "./autogen.sh"
    system "./configure", "--disable-silent-rules",
                          "--with-python3",
                          *std_configure_args
    system "make", "install", "py3execdir=#{prefix/Language::Python.site_packages(python3)}"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <stdio.h>
      #include <cap-ng.h>

      int main(int argc, char *argv[])
      {
        if(capng_have_permitted_capabilities() > -1)
          printf("ok");
      }
    C
    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lcap-ng", "-o", "test"
    assert_equal "ok", `./test`
    system python3, "-c", "import capng"
  end
end
