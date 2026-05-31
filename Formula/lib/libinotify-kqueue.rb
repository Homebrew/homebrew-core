class LibinotifyKqueue < Formula
  desc "Inotify shim for BSD"
  homepage "https://github.com/libinotify-kqueue/libinotify-kqueue"
  url "https://github.com/libinotify-kqueue/libinotify-kqueue/releases/download/20240724/libinotify-20240724.tar.gz"
  sha256 "5cc3fb7af407b17b7daa871cc98bb882716c4b5c296fadfb66bfe86c37cc599c"
  license "MIT"
  head "https://github.com/libinotify-kqueue/libinotify-kqueue.git",
    branch: "master"

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on :macos

  def install
    system "autoreconf", "--force", "--install", "--verbose"
    system "./configure", *std_configure_args
    system "make"
    system "make", "install"
  end

  test do
    # Check if the library is installed
    (testpath/"test.cpp").write <<~EOS
      #include <sys/inotify.h>
      int main() {
        inotify_init();
        return 0;
      }
    EOS
    system ENV.cc, "test.cpp", "-L#{lib}", "-linotify", "-o", "test"
    system "./test"
  end
end
