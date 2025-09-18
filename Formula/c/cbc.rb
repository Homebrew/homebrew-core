class Cbc < Formula
  desc "Mixed integer linear programming solver"
  homepage "https://github.com/coin-or/Cbc"
  url "https://github.com/coin-or/Cbc/archive/refs/tags/releases/2.10.12.tar.gz"
  sha256 "9ed71e4b61668462fc3794c102e26b4bb01a047efbbbcbd69ae7bde1f04f46a8"
  license "EPL-2.0"

  livecheck do
    url :stable
    regex(%r{^releases/v?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:    "e87c268c9db2c8b20388054604f1624339997bd8a2ce7cf8e2c3d4d7ca5b80b6"
    sha256 cellar: :any,                 arm64_sequoia:  "c4383cabc2ad9d393dc2a042d11c36b2c67e080b094e82492d92448671c52853"
    sha256 cellar: :any,                 arm64_sonoma:   "d962ac44681d69aab487032695474a6086701f67836717d92600457f1425403c"
    sha256 cellar: :any,                 arm64_ventura:  "b92f1a725cbf6d7dbdf498a8210612c378d7f4d01d8c449f41a9b29392baadbf"
    sha256 cellar: :any,                 arm64_monterey: "75ee66a89db37032f0c32c8a3e5ff2f96ef38d30d87c7c6ed784f2756e5a1efb"
    sha256 cellar: :any,                 sonoma:         "d5f563de373bec931482fd4c4bbc47da6f5fd1a2de1fcd3593758d27f936495b"
    sha256 cellar: :any,                 ventura:        "24e0a951fa96cc00f232bc99fd59d2ba3c1617e3ac186a918ada15da579c8521"
    sha256 cellar: :any,                 monterey:       "8ada2dccef40eb4b06a043c3189e82add6b9d60f14f75cd7a3a8723fc718b2fb"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "064164adf65fadf8402ba9af954a2fcd87dcaedbd1b4b400c5e2dbdb2422d6aa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a29a22d7f976bd09ed6a0473f64c8bf0ab84a6729fb3d9635133c9bc36dc3fd5"
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
