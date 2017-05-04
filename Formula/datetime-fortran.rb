class DatetimeFortran < Formula
  desc "Fortran time and date manipulation library"
  homepage "https://github.com/milancurcic/datetime-fortran"
  url "https://github.com/milancurcic/datetime-fortran/releases/download/v1.6.0/datetime-fortran-1.6.0.tar.gz"
  sha256 "e46c583bca42e520a05180984315495495da4949267fc155e359524c2bf31e9a"
  revision 1

  bottle do
    sha256 "46f58e0ccb9d289d9d4238782bd71b4b384b3637fb119089bcf191dcbd00a739" => :sierra
    sha256 "0122e54aa32a7f3f511412991a9e7bc0157904071ebe561194417c98671594d1" => :el_capitan
    sha256 "ba610fdf63062196dd75e6ef8721f1647bf7cb62a172e530a10cccc6d1877f28" => :yosemite
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
