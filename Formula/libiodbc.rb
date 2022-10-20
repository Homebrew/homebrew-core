class Libiodbc < Formula
  desc "Database connectivity layer based on ODBC. (alternative to unixodbc)"
  homepage "http://www.iodbc.org/dataspace/iodbc/wiki/iODBC/"
  url "https://github.com/openlink/iODBC/archive/v3.52.15.tar.gz"
  sha256 "f6b376b6dffb4807343d6d612ed527089f99869ed91bab0bbbb47fdea5ed6ace"
  license any_of: ["BSD-3-Clause", "LGPL-2.0-only"]

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "b282396d02085ccf612c0625706f962d7010f05e5e02c325337fadd7de514e7a"
    sha256 cellar: :any,                 arm64_big_sur:  "5147321e5b94a093ccb0e3ecf942cc69022c37a79ddac432185be9053353a797"
    sha256 cellar: :any,                 monterey:       "e4af763bc358e57ce1815acd219c6a269a68bac9e98dad8b6a44ee86013d24aa"
    sha256 cellar: :any,                 big_sur:        "ee25a27296ec772e888b1631f4f937ddba2e848c550f3ae0af70abb3c5089cf9"
    sha256 cellar: :any,                 catalina:       "1ef55cd149e392eca7c0708cc24a928d5b762e672e2651902b8fea24f2d76f20"
    sha256 cellar: :any,                 mojave:         "e8afda31c8d863560d0b45da2e0b09f452daca6bbe6b37762366743843f0f3b3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a2d26a3f634393d8351e612de1646ea705b61c9c758a10d7efd384a27055514b"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  conflicts_with "unixodbc", because: "both install `odbcinst.h`"

  def install
    system "./autogen.sh"
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system bin/"iodbc-config", "--version"
  end
end
