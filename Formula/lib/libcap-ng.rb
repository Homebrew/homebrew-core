class LibcapNg < Formula
  desc "Library for Linux that makes using posix capabilities easy"
  homepage "https://people.redhat.com/sgrubb/libcap-ng/"
  url "https://github.com/stevegrubb/libcap-ng/archive/refs/tags/v0.9.1.tar.gz"
  sha256 "52418b8940f83dcc00dcd01d187e67c3399ff65f3fa558442e3a21b415cc46c0"
  license all_of: ["LGPL-2.1-or-later", "GPL-2.0-or-later"]
  head "https://github.com/stevegrubb/libcap-ng.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_linux:  "011f10f452c4e4dd3206ee56692ce4f8bc625b24a45a06e14aae2c4578c9a9ab"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "d06d023cf2e717f01befaa68e02a73bcaaad7f52e6ed61c004165a54a4c27d91"
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
