class LibxdgBasedir < Formula
  desc "C implementation of the XDG Base Directory specifications"
  homepage "https://github.com/devnev/libxdg-basedir"
  url "https://github.com/devnev/libxdg-basedir/archive/libxdg-basedir-1.2.0.tar.gz"
  sha256 "1c2b0032a539033313b5be2e48ddd0ae94c84faf21d93956d53562eef4614868"

  bottle do
    cellar :any
    sha256 "d737fa3c4f67f250dd7443702868bc4204cff2d05bc7bf0efe54e7efe64655fa" => :mojave
    sha256 "f5b940765c84d65ecd0baddcc03eab2bc612a090db48e6309b411f13e7a3c714" => :high_sierra
    sha256 "00953ec922b6ebac6e27b1f8e1139fcc1cc5b9f8312dc8d0ebe69778c884c1b7" => :sierra
    sha256 "30b3e34a46470f11d90ca01aebd2b2d1fbaa6cc8a05c1bcec7067d40fdec75d1" => :el_capitan
    sha256 "7e165b0e949f559789981a5c0e0fd68bbf478943a0c9b03ad3778cecb0219691" => :yosemite
    sha256 "5c7bfadf4ca8b26c077eea7480df5a4ca3634b5823860a06ce2756050acbe84a" => :mavericks
    sha256 "63250688af20be1cb163530ea3849e4ca8b4ce93e15040904936414995af93f0" => :mountain_lion
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  def install
    system "./autogen.sh", "--disable-dependency-tracking",
                           "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <basedir.h>
      int main() {
        xdgHandle handle;
        if (!xdgInitHandle(&handle)) return 1;
        xdgWipeHandle(&handle);
        return 0;
      }
    EOS
    system ENV.cc, "test.cpp", "-L#{lib}", "-lxdg-basedir", "-o", "test"
    system "./test"
  end
end
