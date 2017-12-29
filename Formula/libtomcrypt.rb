class Libtomcrypt < Formula
  desc "Comprehensive, modular and portable cryptographic toolkit"
  homepage "http://www.libtom.net"
  url "https://github.com/libtom/libtomcrypt/archive/v1.18.0.tar.gz"
  sha256 "bdba1499dab3bf3365fa75553f069eba7bea392e8f9e0381aa0e950a08bd85ba"

  option "with-gmp", "enable gmp as MPI provider"
  option "with-libtommath", "enable libtommath as MPI provider"

  depends_on "gmp" => :optional
  depends_on "libtommath" => :optional

  def install
    ENV.append "CFLAGS", "-DUSE_GMP -DGMP_DESC" if build.with?("gmp")
    ENV.append "EXTRALIBS", "-lgmp" if build.with?("gmp")
    ENV.append "CFLAGS", "-DUSE_LTM -DLTM_DESC" if build.with?("libtommath")
    ENV.append "EXTRALIBS", "-ltommath" if build.with?("libtommath")
    system "make", "install", "PREFIX=#{prefix}"
    system "make", "test"
    pkgshare.install "./test"
    (pkgshare/"tests").install "tests/test.key"
  end

  test do
    cd pkgshare do
      system "./test"
    end
  end
end
