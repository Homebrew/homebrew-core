class Libwps < Formula
  desc "Library to import files in MS Works format"
  homepage "https://libwps.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/libwps/libwps/libwps-0.4.14/libwps-0.4.14.tar.xz"
  sha256 "365b968e270e85a8469c6b160aa6af5619a4e6c995dbb04c1ecc1b4dd13e80de"
  license any_of: ["LGPL-2.1-or-later", "MPL-2.0"]

  livecheck do
    url :stable
    regex(%r{url=.*?/libwps(?:/|[._-])v?(\d+(?:\.\d+)+)\.t}i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:    "a1a1238d044325d8d266d1d13531ce09f837f8fe7ee2fe1474971456f3b5fe6b"
    sha256 cellar: :any,                 arm64_sequoia:  "1fcecd4b70835db56d8ee1e19e7fb07ab34cd1f43d64dce1900baa57a59b2949"
    sha256 cellar: :any,                 arm64_sonoma:   "53e4b189ac3f6a5707904498385226b759f0c8a222378682cad4303c0169b83e"
    sha256 cellar: :any,                 arm64_ventura:  "6d72183ffc9b82c287d94ccdb14d6e78a71da5a62d10c10f2ff50ab74908087f"
    sha256 cellar: :any,                 arm64_monterey: "4ea281eea24cce797c6f21a41a6d9be0911343b28bf58b5e4585442959745127"
    sha256 cellar: :any,                 arm64_big_sur:  "1fb8baf32244abfb5d39ffc8f5286a7fa0111333e57c3d43f1f337f6ff43100a"
    sha256 cellar: :any,                 sonoma:         "eafcfcc4568c94cb334613505826f62aeee27380acab0ddff6f88c5e832ee128"
    sha256 cellar: :any,                 ventura:        "05d18e5787514170da6f2b7e2bb58f449bb4c282c9e35ff32ddf4b13747ee458"
    sha256 cellar: :any,                 monterey:       "6609484542bfcf5046702cf470e20da2dd99ef1597b6e60ca08858e5975afbe6"
    sha256 cellar: :any,                 big_sur:        "bf9c54ae1889bf3dcc90034d9b5a11bd14c452b69463343c3bd8f221031109d6"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "66e66c4fe9ca468d38f275f3fafeb4c5fcdabffc65f7f09c4256f10454421a14"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1947ed7197be31c9abf52b092a535de6d3d1416c9fef915661ba81da4cee37b6"
  end

  depends_on "pkgconf" => :build
  depends_on "librevenge"

  def install
    # Installing Doxygen docs trips up make install
    system "./configure", "--without-docs", *std_configure_args
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      #include <libwps/libwps.h>
      int main() {
        return libwps::WPS_OK;
      }
    CPP
    system ENV.cc, "test.cpp", "-o", "test",
                  "-I#{include}/libwps-0.4",
                  "-I#{Formula["librevenge"].include}/librevenge-0.0",
                  "-L#{lib}", "-lwps-0.4",
                  "-L#{Formula["librevenge"].lib}", "-lrevenge-0.0"
    system "./test"
  end
end
