class DatetimeFortran < Formula
  desc "Fortran time and date manipulation library"
  homepage "https://github.com/milancurcic/datetime-fortran"
  url "https://github.com/milancurcic/datetime-fortran/releases/download/v1.6.0/datetime-fortran-1.6.0.tar.gz"
  sha256 "e46c583bca42e520a05180984315495495da4949267fc155e359524c2bf31e9a"

  bottle do
    sha256 "d311aff0507c9c6e40189b7d1ad23d4f10763f4021f2dcaeaced7ed6ab1b0500" => :sierra
    sha256 "b2b94b5bb0ab17c0a25ce9c87590041f40095a3cfdacc4d49fda4e17eb90d43b" => :el_capitan
    sha256 "4c658f924f82c91531e59233a1c818ef17a897d58379ecec360cb8cba3b13da9" => :yosemite
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
