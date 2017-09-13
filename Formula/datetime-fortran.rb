class DatetimeFortran < Formula
  desc "Fortran time and date manipulation library"
  homepage "https://github.com/milancurcic/datetime-fortran"
  url "https://github.com/milancurcic/datetime-fortran/releases/download/v1.6.0/datetime-fortran-1.6.0.tar.gz"
  sha256 "e46c583bca42e520a05180984315495495da4949267fc155e359524c2bf31e9a"
  revision 1

  bottle do
    sha256 "a9fa586679b05377aeeeea71e2ae1932c630fb43a89eb7314276bc6fbbdd3383" => :sierra
    sha256 "2fe1c9faee819e539afa30b8bbceb203bea388de7609418d80ee5fed4e716e7a" => :el_capitan
    sha256 "ba3ad1df170d2027251c9c322e4250e8c49e4af1786a3f42d66f08562eb25a16" => :yosemite
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
