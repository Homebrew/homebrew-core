class DatetimeFortran < Formula
  desc "Fortran time and date manipulation library"
  homepage "https://github.com/milancurcic/datetime-fortran"
  url "https://github.com/milancurcic/datetime-fortran/releases/download/v1.4.3/datetime-fortran-1.4.3.tar.gz"
  sha256 "e3cb874fde0d36a97e282689eef459e8ce1973183d9acd95568149bc2d74436d"

  bottle do
    sha256 "7b03fe98869699a25af3829a35ebff06291706415e3c7416c83d7af3dc5e98e4" => :sierra
    sha256 "10ee60591583b2c8a4b9d26bfdc897dce904b7eb2bc7ce4a99efb10bc77e7266" => :el_capitan
    sha256 "1a423e033e041575e5b03f2edc7b7547905a4b1cff1b15c54c505cb8304d2d1f" => :yosemite
    sha256 "90fdfc9f3a1e8f453e009bdf4edb82bc64df1c10b05f1abbbf2f91a3e50d4148" => :mavericks
  end

  head do
    url "https://github.com/milancurcic/datetime-fortran.git"

    depends_on "autoconf"   => :build
    depends_on "automake"   => :build
    depends_on "pkg-config" => :build
  end

  option "without-test", "Skip build time tests (Not recommended)"
  depends_on :fortran

  def install
    system "autoreconf", "-fvi" if build.head?
    system "./configure", "--prefix=#{prefix}",
                          "--disable-silent-rules"
    system "make", "check" if build.with? "test"
    system "make", "install"
    (pkgshare/"test").install "src/tests/datetime_tests.f90"
  end

  test do
    ENV.fortran
    system ENV.fc, "-odatetime_test", "-ldatetime", "-I#{HOMEBREW_PREFIX}/include", pkgshare/"test/datetime_tests.f90"
    system testpath/"datetime_test"
  end
end
