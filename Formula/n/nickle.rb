class Nickle < Formula
  desc "Desk calculator language"
  homepage "https://www.nickle.org/"
  url "https://deb.debian.org/debian/pool/main/n/nickle/nickle_2.102.tar.xz"
  sha256 "a997f211b47ca53bc000a2fc64a95282dd7eb7671a8e649f8196b58352b643a3"
  license "MIT"
  head "https://keithp.com/cgit/nickle.git", branch: "master"

  livecheck do
    url "https://deb.debian.org/debian/pool/main/n/nickle/"
    regex(/href=.*?nickle[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sequoia: "2fdc47d6d5048414dfb052a1435db3384faf66f24aa5676bc44d6103b6566b5e"
    sha256 arm64_sonoma:  "44a28de3bfd6cbcbd1c3241cc6c159eb6c1d872b66bcda0b9753a9cff6f73829"
    sha256 arm64_ventura: "43b3243b4a9484fda1eea6f44ce4e0f2e205d4f1a1a089f4d8bfce6c0f8cea52"
    sha256 sonoma:        "a545c7cf04ec60df69b247257d58305914b4e799604afa959cae74e616debf89"
    sha256 ventura:       "0c7c8b844b443aed8417bc9e0061cd6d242d6f8fb89d7f7e2efdb6efe70c7080"
    sha256 x86_64_linux:  "714be532767cf1fadc8094350bec6e70459a8dd8e891a8eeba3de01099638dde"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "flex" => :build # conflicting types for 'yyget_leng'
  depends_on "pkgconf" => :build
  depends_on "readline"

  uses_from_macos "bison" => :build
  uses_from_macos "libedit"

  def install
    ENV["CC_FOR_BUILD"] = ENV.cc
    system "./autogen.sh", *std_configure_args
    system "make", "install"
  end

  test do
    assert_equal "4", shell_output("#{bin}/nickle -e '2+2'").chomp
  end
end
