class CAres < Formula
  desc "Asynchronous DNS library"
  homepage "https://c-ares.haxx.se/"
  url "https://c-ares.haxx.se/download/c-ares-1.16.0.tar.gz"
  sha256 "de058ad7c128156e2db6dc98b8a359924d6f210a1b99dd36ba15c8f839a83a89"

  bottle do
    cellar :any
    sha256 "e2382f3a03ef2e311eacd300f256a9aff61f706337b9c6e0ec0ee66be68b373b" => :catalina
    sha256 "5b47cb575d75bad499ba8fea85748f6dc05375f4d2dab67ba7a8a189b768d2ae" => :mojave
    sha256 "a91f2fd5c5cf75b08e2631ddec005d7cdcf777b0e380d2fbe1bb8f8643bd9b21" => :high_sierra
  end

  head do
    url "https://github.com/bagder/c-ares.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  def install
    system "./buildconf" if build.head?
    system "./configure", "--prefix=#{prefix}",
                          "--disable-dependency-tracking",
                          "--disable-debug"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <stdio.h>
      #include <ares.h>

      int main()
      {
        ares_library_init(ARES_LIB_INIT_ALL);
        ares_library_cleanup();
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-L#{lib}", "-lcares", "-o", "test"
    system "./test"
  end
end
