class LibcapNg < Formula
  desc "Library for Linux that makes using posix capabilities easy"
  homepage "https://people.redhat.com/sgrubb/libcap-ng"
  url "https://people.redhat.com/sgrubb/libcap-ng/libcap-ng-0.8.3.tar.gz"
  sha256 "bed6f6848e22bb2f83b5f764b2aef0ed393054e803a8e3a8711cb2a39e6b492d"
  license all_of: ["LGPL-2.1-or-later", "GPL-2.0-or-later"]

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, x86_64_linux: "176901077020fcb6da35d20c9e52d9787d09d18965491176bd4f4879587a34a0"
  end

  head do
    url "https://github.com/stevegrubb/libcap-ng.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
    depends_on "m4" => :build
  end

  depends_on "python@3.11" => [:build, :test]
  depends_on "swig" => :build
  depends_on :linux

  def install
    system "./autogen.sh" if build.head?
    system "./configure", *std_configure_args,
                          "--disable-silent-rules",
                          "--without-python",
                          "--with-python3"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <stdio.h>
      #include <cap-ng.h>

      int main(int argc, char *argv[])
      {
        if(capng_have_permitted_capabilities() > -1)
          printf("ok");
      }
    EOS
    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lcap-ng", "-o", "test"
    assert_equal "ok", `./test`
    system "python3.11", "-c", "import capng"
  end
end
