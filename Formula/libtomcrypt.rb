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
    if build.with? "gmp"
      ENV.append "CFLAGS", "-DUSE_GMP -DGMP_DESC"
      ENV.append "EXTRALIBS", "-lgmp"
    end
    if build.with? "libtommath"
      ENV.append "CFLAGS", "-DUSE_LTM -DLTM_DESC"
      ENV.append "EXTRALIBS", "-ltommath"
    end
    system "make", "test"
    system "make", "install", "PREFIX=#{prefix}"
    pkgshare.install "test"
    (pkgshare/"tests").install "tests/test.key"
  end

  test do
    cp_r Dir[pkgshare/"*"], testpath
    system "./test"
  end
end
