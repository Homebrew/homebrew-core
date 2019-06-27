class DatetimeFortran < Formula
  desc "Fortran time and date manipulation library"
  homepage "https://github.com/wavebitscientific/datetime-fortran"
  url "https://github.com/wavebitscientific/datetime-fortran/releases/download/v1.6.1/datetime-fortran-1.6.1.tar.gz"
  sha256 "a503319209c6b9abe2fd0dc46f3b0d096154ac6edad9a106270f82aef6d248c0"

  bottle do
    cellar :any_skip_relocation
    sha256 "d75d7804b0d14697f1b15089bc787e54a0fb57c55670ed21ec99fc577a05de92" => :mojave
    sha256 "ea8405814e9c3e72a192836107d6620a9e3c6996b8c3169675dbe7cb44b345b6" => :high_sierra
    sha256 "4d5d027551164ce741f3dd3915cc4d5b57e246120cd92ac002616c50d05ebd55" => :sierra
    sha256 "5c20d20514118ec61bd76de9dbabe7a84e10d9c7a13c74cc1f95272af60d999e" => :el_capitan
  end

  head do
    url "https://github.com/wavebitscientific/datetime-fortran.git"

    depends_on "autoconf"   => :build
    depends_on "automake"   => :build
    depends_on "pkg-config" => :build
  end

  depends_on "gcc" # for gfortran

  def install
    system "autoreconf", "-fvi" if build.head?
    system "./configure", "--prefix=#{prefix}",
                          "--disable-silent-rules"
    system "make", "install"
    (pkgshare/"test").install "src/tests/datetime_tests.f90"
  end

  test do
    system "gfortran", "-o", "test", "-I#{include}", "-L#{lib}", "-ldatetime",
                       pkgshare/"test/datetime_tests.f90"
    system "./test"
  end
end
