class Libprelude < Formula
  desc "Universal Security Information & Event Management (SIEM) system"
  homepage "https://www.prelude-siem.org/"
  url "https://www.prelude-siem.org/attachments/download/1395/libprelude-5.2.0.tar.gz"
  sha256 "187e025a5d51219810123575b32aa0b40037709a073a775bc3e5a65aa6d6a66e"
  license "GPL-2.0-or-later"
  revision 1

  livecheck do
    url "https://www.prelude-siem.org/projects/prelude/files"
    regex(/href=.*?libprelude[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_monterey: "67d1898db9ecddf2eec804af133dfb7151241ab61d520170bc4778564f12bd4b"
    sha256 arm64_big_sur:  "62a0baace0727b7e5bbbf6dbb826e54604f18c28a3e2d20dda6bad782b50ffde"
    sha256 monterey:       "588eee6b571351091d12034016622a2f787e90b26727e83a81a82f0425a89f14"
    sha256 big_sur:        "c2e8d9d9c831ad24e13cd6d470a08c91c9dad1085ce7fe40e559df77b79a1503"
    sha256 catalina:       "abd1ed78ae980d13cffbe2f7421179f3e416d63f0263b2df2749219bb4ade1ae"
    sha256 mojave:         "99b39668c53d9e1514e8168db34402d897bd9159ecafdc3a377b097748945fb0"
    sha256 x86_64_linux:   "282e13c10a69ba928d5f5597c5e88c33253caef9c5a221eae4f15dc670e125a7"
  end

  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "gnutls"
  depends_on "libgpg-error"
  depends_on "python@3.9"

  def install
    ENV["HAVE_CXX"] = "yes"
    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
      --without-valgrind
      --without-lua
      --without-ruby
      --without-perl
      --without-swig
      --without-python2
      --with-python3=python#{Formula["python@3.9"].version.major_minor}
      --with-libgnutls-prefix=#{Formula["gnutls"].opt_prefix}
    ]

    system "./configure", *args
    system "make"
    system "make", "install"
  end

  test do
    assert_equal prefix.to_s, shell_output(bin/"libprelude-config --prefix").chomp
    assert_equal version.to_s, shell_output(bin/"libprelude-config --version").chomp

    (testpath/"test.c").write <<~EOS
      #include <libprelude/prelude.h>

      int main(int argc, const char* argv[]) {
        int ret = prelude_init(&argc, argv);
        if ( ret < 0 ) {
          prelude_perror(ret, "unable to initialize the prelude library");
          return -1;
        }
      }
    EOS
    system ENV.cc, "test.c", "-L#{lib}", "-lprelude", "-o", "test"
    system "./test"
  end
end
