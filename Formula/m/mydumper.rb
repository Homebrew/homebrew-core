class Mydumper < Formula
  desc "MySQL logical backup tool"
  homepage "https://github.com/mydumper/mydumper"
  url "https://github.com/mydumper/mydumper/archive/refs/tags/v0.21.3-1.tar.gz"
  sha256 "a6a6b4db319e67663410f26462597dfe22a0b34600ee35ada4180df07d8c6ce7"
  license "GPL-3.0-or-later"
  head "https://github.com/mydumper/mydumper.git", branch: "master"

  livecheck do
    url :stable
    regex(/v?(\d+(?:\.\d+)+(-\d+)?)/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "6ceae1418a596ebf672a7f921bcbb298b1428408b1fd23e7ef14877c19b3ba39"
    sha256 cellar: :any,                 arm64_sequoia: "81b5f87b490b85a6d817c153027495a6054d753b5003b3a72b1816343643a44a"
    sha256 cellar: :any,                 arm64_sonoma:  "d34929334ef51c9f56e40536e16ef56af28957095bbadbdf449f635895e59e7d"
    sha256 cellar: :any,                 sonoma:        "c1e1e4fe3ccb3b602d2fcf678e9c0626374cc970f53c2c3d9ffd3bd74d19cc9a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "151822263f8176405cf8c3dc1329c1c1736294512d756b5b256c439e0e3bc010"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "83fd06ce8a05b9badcd029600ebe977effdf8146e3718e602d89f39b2b9cf61b"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "sphinx-doc" => :build
  depends_on "glib"
  depends_on "mariadb-connector-c"
  depends_on "pcre2"

  on_macos do
    depends_on "openssl@3"
  end

  def install
    # Avoid installing config into /etc
    inreplace "CMakeLists.txt", "/etc", etc

    # Override location of mysql-client
    args = %W[
      -DMYSQL_CONFIG_PREFER_PATH=#{Formula["mariadb-connector-c"].opt_bin}
      -DCMAKE_POLICY_VERSION_MINIMUM=3.5
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    system bin/"mydumper", "--help"
  end
end
