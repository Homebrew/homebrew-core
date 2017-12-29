class Libtomcrypt < Formula
  desc "Comprehensive, modular and portable cryptographic toolkit"
  homepage "http://www.libtom.net"
  url "https://github.com/libtom/libtomcrypt/archive/v1.18.0.tar.gz"
  sha256 "bdba1499dab3bf3365fa75553f069eba7bea392e8f9e0381aa0e950a08bd85ba"

  bottle do
    cellar :any_skip_relocation
    sha256 "d63f50b85f7049c447cb862c503fcdd1fc6f9548961634513aa155cca9f6ea82" => :high_sierra
    sha256 "e670af84b0cf4fcae425c7d09dc848c13737966a8209b19ae57606c8ce748aa0" => :sierra
    sha256 "35739dedeb6932b60b46c725b03d3609f933a0cac4b180d59a9c8f38e8272923" => :el_capitan
  end

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
