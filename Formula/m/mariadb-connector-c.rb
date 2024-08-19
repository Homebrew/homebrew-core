class MariadbConnectorC < Formula
  desc "MariaDB database connector for C applications"
  homepage "https://mariadb.org/download/?tab=connector&prod=connector-c"
  url "https://archive.mariadb.org/connector-c-3.3.10/mariadb-connector-c-3.3.10-src.tar.gz"
  mirror "https://fossies.org/linux/misc/mariadb-connector-c-3.3.10-src.tar.gz/"
  sha256 "fb156c40147d375ba7ce85d554a67ce4080b2aeb523c6438030f6fe4d680378b"
  license "LGPL-2.1-or-later"
  head "https://github.com/mariadb-corporation/mariadb-connector-c.git", branch: "3.3"

  # The REST API may omit the newest major/minor versions unless the
  # `olderReleases` parameter is set to `true`.
  livecheck do
    url "https://downloads.mariadb.org/rest-api/connector-c/all-releases/?olderReleases=true"
    strategy :json do |json|
      json["releases"]&.map do |_, group|
        group["children"]&.map do |release|
          next if release["status"] != "stable"

          release["release_number"]
        end
      end&.flatten
    end
  end

  bottle do
    sha256 arm64_sonoma:   "9fecdeb4de3fca9352714ef3da8d1a3e39f24c27cc5dcce3f96af7dae2347a4d"
    sha256 arm64_ventura:  "301289e2a7caef0989327d7fee7c421b5f2ef939cac8bc179fc605ce21c78d88"
    sha256 arm64_monterey: "4b01573be81162ac4c70a04d2a7095d72a3b9566d036f167e8ac0b7273b2a756"
    sha256 sonoma:         "94b265528bf4942c59609605a3012972262c2a98b95d50da90d8fa6d097b07c3"
    sha256 ventura:        "667256ba3261c68d6b9800695cfbdea41d2c013d1704a73b4d8554b9f5ab0e12"
    sha256 monterey:       "bbc4cedcf0901e5f98f30245a62ab7a0f7ea5e1d3e10d7e86af678ea6cf2a97e"
    sha256 x86_64_linux:   "bee14af0524f508a0279615b0351fb082e25aa78a835c973b68e89bb2ee37d7b"
  end

  depends_on "cmake" => :build
  depends_on "openssl@3"

  uses_from_macos "curl"
  uses_from_macos "krb5"
  uses_from_macos "zlib"

  on_linux do
    depends_on "zstd"
  end

  conflicts_with "mariadb", because: "both install `mariadb_config`"

  def install
    args = std_cmake_args
    args << "-DWITH_OPENSSL=On"
    args << "-DWITH_EXTERNAL_ZLIB=On"
    args << "-DOPENSSL_INCLUDE_DIR=#{Formula["openssl@3"].opt_include}"
    args << "-DINSTALL_MANDIR=#{share}"
    args << "-DCOMPILATION_COMMENT=Homebrew"

    system "cmake", ".", *args
    system "make", "install"
  end

  test do
    system bin/"mariadb_config", "--cflags"
  end
end
