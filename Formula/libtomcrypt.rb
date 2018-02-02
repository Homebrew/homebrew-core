class Libtomcrypt < Formula
  desc "Comprehensive, modular and portable cryptographic toolkit"
  homepage "http://www.libtom.net"
  url "https://github.com/libtom/libtomcrypt/archive/v1.18.1.tar.gz"
  sha256 "e1319d77bf8ac296b69cf68f66e4dadfb68a8519bd684cc83d29b8d6754d10ef"

  bottle do
    cellar :any_skip_relocation
    sha256 "db05bfc16ef60355d9079efeb274e9106755bedb4e891ea2b9e455bf784a1c38" => :high_sierra
    sha256 "031781e5baf4fad0febb66182e66b99a4f32aad9d6376eaf7f70c2496ed6fc5c" => :sierra
    sha256 "bb0d91090b6bbe1f49fa14d32fe137f08a80cd5d5a2a79dd79e641f8ab57794c" => :el_capitan
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
