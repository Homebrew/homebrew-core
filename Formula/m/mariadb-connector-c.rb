class MariadbConnectorC < Formula
  desc "MariaDB database connector for C applications"
  homepage "https://mariadb.org/download/?tab=connector&prod=connector-c"
  # TODO: Remove backward compatibility library symlinks on breaking version bump
  url "https://archive.mariadb.org/connector-c-3.4.8/mariadb-connector-c-3.4.8-src.tar.gz"
  mirror "https://fossies.org/linux/misc/mariadb-connector-c-3.4.8-src.tar.gz/"
  sha256 "156aed3b49f857d0ac74fb76f1982968bcbfd8382da3f5b6ae71f616729920d7"
  license "LGPL-2.1-or-later"
  revision 2
  compatibility_version 1
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
    sha256 arm64_tahoe:   "de1e4d22f9d577eeb32c56ddcf82e0e6dc44aca1350063b9dd4f667032267620"
    sha256 arm64_sequoia: "edbeba92565fd634577cceb847f5771da58d7c4c41c655fad0960db29c753180"
    sha256 arm64_sonoma:  "a76dc8a4499da20be32ff52d31f3f8bdb94ab699e1eb9233997f10a1d0b9e6d6"
    sha256 sonoma:        "2621fc4a14d2490d3f87729cf81a9ee3a992295d0567c29c4bd2f8f9d12b1c69"
    sha256 arm64_linux:   "c15a6668689195b36ac3cac88561ca0bc95ff3e5139e1610be6b569657775f6c"
    sha256 x86_64_linux:  "483950acadce3936ade59313c2211cc271bc3be8f6cb2a87167689da7f1c0ec4"
  end

  keg_only "it conflicts with mariadb"

  depends_on "cmake" => :build
  depends_on "openssl@4"
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
