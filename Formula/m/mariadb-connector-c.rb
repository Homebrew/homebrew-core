class MariadbConnectorC < Formula
  desc "MariaDB database connector for C applications"
  homepage "https://mariadb.org/download/?tab=connector&prod=connector-c"
  # TODO: Remove backward compatibility library symlinks on breaking version bump
  url "https://archive.mariadb.org/connector-c-3.4.8/mariadb-connector-c-3.4.8-src.tar.gz"
  mirror "https://fossies.org/linux/misc/mariadb-connector-c-3.4.8-src.tar.gz/"
  sha256 "156aed3b49f857d0ac74fb76f1982968bcbfd8382da3f5b6ae71f616729920d7"
  license "LGPL-2.1-or-later"
  revision 1
  head "https://github.com/mariadb-corporation/mariadb-connector-c.git", branch: "3.4"

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
    sha256 arm64_tahoe:   "01d614467287c61b78cb78e9234d1c445dbd79beb4b9c12bf99ed0beb1a01535"
    sha256 arm64_sequoia: "0970698d342c0c98b3a4efeb408e764d4ca12d6c015d2cd41e0f1700bab34bdc"
    sha256 arm64_sonoma:  "78e4cc822105fd0699d3913dedb784b5d30596a0ee140932071933afd1b1a338"
    sha256 sonoma:        "79501ef30e2ab77c3894897428269d33b80a9cb1c7a9ee4df3a119ecc508473a"
    sha256 arm64_linux:   "b3242cc136211ae92f6559f959e94ff963fa6822900784c0f98c7893e30cf01d"
    sha256 x86_64_linux:  "9a2b2d89b014881733d2ee25d06a4ce7f0c17bcdb159059036ed068784a6d415"
  end

  keg_only "it conflicts with mariadb"

  depends_on "cmake" => :build
  depends_on "openssl@3"
  depends_on "zstd"

  uses_from_macos "curl"
  uses_from_macos "krb5"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    rm_r "external"

    # -DINSTALL_* are relative to prefix
    args = %w[
      -DINSTALL_LIBDIR=lib
      -DINSTALL_MANDIR=share/man
      -DWITH_EXTERNAL_ZLIB=ON
      -DWITH_MYSQLCOMPAT=ON
      -DWITH_UNIT_TESTS=OFF
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    # Add mysql_config symlink for compatibility which simplifies building
    # some dependents. This is done in the full `mariadb` installation[^1]
    # but not in the standalone `mariadb-connector-c`.
    #
    # [^1]: https://github.com/MariaDB/server/blob/main/cmake/symlinks.cmake
    bin.install_symlink "mariadb_config" => "mysql_config"

    # Temporary symlinks for backwards compatibility.
    # TODO: Remove in future version update.
    (lib/"mariadb").install_symlink lib.glob(shared_library("*"))

    # TODO: Automatically compress manpages in brew
    Utils::Gzip.compress(*man3.glob("*.3"))
  end

  test do
    system bin/"mariadb_config", "--cflags"
  end
end
