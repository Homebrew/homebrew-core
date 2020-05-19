class DatetimeFortran < Formula
  desc "Fortran time and date manipulation library"
  homepage "https://github.com/wavebitscientific/datetime-fortran"
  url "https://github.com/wavebitscientific/datetime-fortran/releases/download/v1.7.0/datetime-fortran-1.7.0.tar.gz"
  sha256 "cff4c1f53af87a9f8f31256a3e04176f887cc3e947a4540481ade4139baf0d6f"

  bottle do
    cellar :any_skip_relocation
    sha256 "73f230fd02a4dcc810e5dff0b6c91fd652d71d205aabad40b781fb5cc4b85ce3" => :catalina
    sha256 "53b0711bb7bae0a6ceab81d1c81475ab7d9b4a3faf9293ef5ef425d9f008cd51" => :mojave
    sha256 "4da37b7d4a520168a526cc63ed413c1bea31f769b02a7a471de1cf854623a379" => :high_sierra
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
    (pkgshare/"test").install "tests/datetime_tests.f90"
  end

  test do
    system "gfortran", "-o", "test", "-I#{include}", "-L#{lib}", "-ldatetime",
                       pkgshare/"test/datetime_tests.f90"
    system "./test"
  end
end
