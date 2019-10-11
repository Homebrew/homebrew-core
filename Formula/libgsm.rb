class Libgsm < Formula
  desc "Lossy speech compression library"
  homepage "http://www.quut.com/gsm/"
  url "http://www.quut.com/gsm/gsm-1.0.18.tar.gz"
  sha256 "04f68087c3348bf156b78d59f4d8aff545da7f6e14f33be8f47d33f4efae2a10"

  bottle do
    cellar :any
    sha256 "40477d520f2e5af9f9557276c9ae4724c39cc79166f38d47347754839e679e1e" => :catalina
    sha256 "b06d7e8a936f19fe705d0b5cfe9a0da91d78acbcec4521fe1b61fcb37a97a77d" => :mojave
    sha256 "430c06d59d788bae3b9081924d68bb8c800cf0792fb533219e0e6c94887a0e22" => :high_sierra
    sha256 "1efa5fae6b9cf7bc802a42845836522bdb89fa0acf5bae88ca36dd75b823a5de" => :sierra
    sha256 "72ab3562f8bafc91a0c6dd0149956ed1c1e97ddacb409a695e2b4581317a9260" => :el_capitan
  end

  # Builds a dynamic library for gsm, this package is no longer developed
  # upstream. Patch taken from Debian and modified to build a dylib.
  patch do
    url "https://gist.githubusercontent.com/dholm/5840964/raw/1e2bea34876b3f7583888b2284b0e51d6f0e21f4/gistfile1.txt"
    sha256 "3b47c28991df93b5c23659011e9d99feecade8f2623762041a5dcc0f5686ffd9"
  end

  def install
    ENV.append_to_cflags "-c -O2 -DNeedFunctionPrototypes=1"

    # Only the targets for which a directory exists will be installed
    bin.mkpath
    lib.mkpath
    include.mkpath
    man1.mkpath
    man3.mkpath

    # Dynamic library must be built first
    system "make", "lib/libgsm.1.0.13.dylib",
           "CC=#{ENV.cc}", "CCFLAGS=#{ENV.cflags}",
           "LDFLAGS=#{ENV.ldflags}"
    system "make", "all",
           "CC=#{ENV.cc}", "CCFLAGS=#{ENV.cflags}",
           "LDFLAGS=#{ENV.ldflags}"
    system "make", "install",
           "INSTALL_ROOT=#{prefix}",
           "GSM_INSTALL_INC=#{include}"
    lib.install Dir["lib/*dylib"]
  end
end
