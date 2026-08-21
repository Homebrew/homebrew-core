class Cbc < Formula
  desc "Mixed integer linear programming solver"
  homepage "https://github.com/coin-or/Cbc"
  url "https://github.com/coin-or/Cbc/archive/refs/tags/releases/2.10.13.tar.gz"
  sha256 "62fde44dcf6f3d05c5cd291d7435cdd1b7e8acd3c78ec481dd39fe49cbc40399"
  license "EPL-2.0"
  compatibility_version 1

  livecheck do
    url :stable
    regex(%r{^releases/v?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "52ccb68fba8383cbf511aa50e4995c895319c8922f21fedbda41e9f620f91736"
    sha256 cellar: :any,                 arm64_sequoia: "d2c10a57a7d316a86559b3d3cfe129a42b7ffc7dbbfbb5c286e29bc802c78e5a"
    sha256 cellar: :any,                 arm64_sonoma:  "03cfdafce62bf09ea636af2558b833b98eed4fcb9b1b0abb91c8172035dbd960"
    sha256 cellar: :any,                 sonoma:        "c67568c5827d8a2d6cae9ccd452844ec85f83d22a430a790be47635003831d6c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bf429b4ca41fbe33f560083c046607aab8bb28aad6e7fd2c300e379c79e73814"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f710f8fde9355103a280120d28c6f1fd75b96fd9f2761d50ffaf7de856276bcf"
  end

  depends_on "pkgconf" => [:build, :test]

  depends_on "cgl"
  depends_on "clp"
  depends_on "coinutils"
  depends_on "osi"

  on_macos do
    depends_on "openblas"
  end

  conflicts_with "libcouchbase", because: "both install `cbc` binaries"

  def install
    # Work around for:
    # Error 1: "mkdir: #{include}/cbc/coin: File exists."
    (include/"cbc/coin").mkpath

    system "./configure", "--disable-silent-rules",
                          "--includedir=#{include}/cbc",
                          "--enable-cbc-parallel",
                          *std_configure_args
    system "make", "install"

    pkgshare.install "Cbc/examples"
  end

  test do
    cp_r pkgshare/"examples/.", testpath

    pkg_config_flags = shell_output("pkg-config --cflags --libs cbc").chomp.split
    system ENV.cxx, "-std=c++11", "sudoku.cpp", *pkg_config_flags, "-o", "sudoku"
    assert_match "solution is valid", shell_output("./sudoku")
  end
end
