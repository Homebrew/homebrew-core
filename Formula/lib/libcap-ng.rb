class LibcapNg < Formula
  desc "Library for Linux that makes using posix capabilities easy"
  homepage "https://people.redhat.com/sgrubb/libcap-ng/"
  url "https://github.com/stevegrubb/libcap-ng/archive/refs/tags/v0.9.3.tar.gz"
  sha256 "fe11ebbb55904763b3532f19069f13ec319042634620180a03bd4653d301563e"
  license all_of: ["LGPL-2.1-or-later", "GPL-2.0-or-later"]
  head "https://github.com/stevegrubb/libcap-ng.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_linux:  "6dd678906bd60a3abd618109a3bf6e0968c2ba1983251a5345192f88336603ab"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "50b33e8da4ed5daf4ed149254786fe602c5f33cdb8700148ad64c5421633eada"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "m4" => :build
  depends_on "pkgconf" => :build
  depends_on "python-setuptools" => :build
  depends_on "python@3.14" => [:build, :test]
  depends_on "swig" => :build
  depends_on :linux

  def python3
    "python3.14"
  end

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
