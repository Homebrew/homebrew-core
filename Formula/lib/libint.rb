class Libint < Formula
  desc "Library for computing electron repulsion integrals efficiently"
  homepage "https://github.com/evaleev/libint"
  url "https://github.com/evaleev/libint/archive/v2.7.2.tar.gz"
  sha256 "fd0466ce9eb6786b8c5bbe3d510e387ed44b198a163264dfd7e60b337e295fd9"
  license all_of: ["GPL-3.0-or-later", "LGPL-3.0-or-later"]

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_ventura:  "523320b75906b2bdac83d064a49e19901ad7cab5d0cc74c280e9000872a522d7"
    sha256 cellar: :any,                 arm64_monterey: "105ae017c2932910f75659b0578e38a32dc176872dc2b0c7e63c966137701de0"
    sha256 cellar: :any,                 arm64_big_sur:  "8542ba3fe2ee8df6b741cf8ee6875d1c953eb4d16b73938b4e8fa9a419f602ae"
    sha256 cellar: :any,                 ventura:        "0846283a6924201526a50344630388673e24ff20827323bc6d1e9c8ff4923df1"
    sha256 cellar: :any,                 monterey:       "ceadf0a44442635a8f096ebfe3c46ed586e672c678fb3726443d12d926676096"
    sha256 cellar: :any,                 big_sur:        "9817ff01a79a7a7a8f8e72f03b705d2535de6962f54cc3175a7e2ddab11ecba0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "acaebd25a4de28337f45b7a0168e0730e849408778fffd2f8b036a2578ec2504"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => [:build, :test]
  depends_on "boost"
  depends_on "eigen"
  depends_on "mpfr"
  depends_on "python@3.11"

  def install
    system "glibtoolize", "--install", "--force"
    system "./autogen.sh"
    system "./configure", "--enable-shared", "--disable-static", *std_configure_args
    system "make"
    system "make", "install"
    pkgshare.install "tests/hartree-fock/hartree-fock.cc"
    pkgshare.install "tests/hartree-fock/h2o.xyz"
  end

  test do
    system ENV.cxx, "-std=c++11", pkgshare/"hartree-fock.cc",
      *shell_output("pkg-config --cflags --libs libint2").chomp.split,
      "-I#{Formula["eigen"].opt_include}/eigen3",
      "-o", "hartree-fock"
    system "./hartree-fock", pkgshare/"h2o.xyz"
  end
end
