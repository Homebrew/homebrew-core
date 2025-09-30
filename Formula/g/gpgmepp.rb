class Gpgmepp < Formula
  desc "C++ bindings for gpgme"
  homepage "https://www.gnupg.org/related_software/gpgme/"
  url "https://www.gnupg.org/ftp/gcrypt/gpgmepp/gpgmepp-2.0.0.tar.xz"
  sha256 "d4796049c06708a26f3096f748ef095347e1a3c1e570561701fe952c3f565382"
  license "LGPL-2.1-or-later"

  livecheck do
    url "https://gnupg.org/ftp/gcrypt/gpgmepp/"
    regex(/href=.*?gpgmepp[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "a92d04950e7ed7477e8e2f6323eee90f2f07acd03c374561e614c0c1b7d0207e"
    sha256 cellar: :any,                 arm64_sequoia: "13e6462a3ff4e89c924f8e023b151a0721907d716707daf04b28656173edc732"
    sha256 cellar: :any,                 arm64_sonoma:  "01f07cfcb3f93b7bc6609fc3399e45bddd7e1e9343d8f11378b8edec0b9abec7"
    sha256 cellar: :any,                 arm64_ventura: "3f6762cbcae50c7f780889beabfeae5b74df50657181e5aeadfc2da8cf0ad0cb"
    sha256 cellar: :any,                 sonoma:        "d34c39da789e4b801fe5885fc6b11ee105d92f01336e12e78c2bc918c569d8a0"
    sha256 cellar: :any,                 ventura:       "71643216cf7c6ab93f6b3728613741b58908386ab67ebaa3d7ddc52796c14172"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0cce58bc668ff2554392efd5d00861871edad5a3904a193405d6524a14639cc4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0b9eee0c77dff5bb7ae714c7976b05d4277198eb467afec6ddcec64029918730"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => [:build, :test]
  depends_on "gpgme"

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    pkgshare.install "tests"
  end

  test do
    cp_r (pkgshare/"tests").children, testpath

    flags = shell_output("pkgconf --cflags --libs gpgmepp").chomp.split
    system ENV.cxx, "-std=c++17", "run-genrandom.cpp", "-o", "test",
                    "-I#{include}/gpgme++", *flags
    system "./test", "--number", "10"
  end
end
