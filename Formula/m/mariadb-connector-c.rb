class MariadbConnectorC < Formula
  desc "MariaDB database connector for C applications"
  homepage "https://mariadb.org/download/?tab=connector&prod=connector-c"
  # TODO: Remove backward compatibility library symlinks on breaking version bump
  url "https://archive.mariadb.org/connector-c-3.4.3/mariadb-connector-c-3.4.3-src.tar.gz"
  mirror "https://fossies.org/linux/misc/mariadb-connector-c-3.4.3-src.tar.gz/"
  sha256 "a9033833a88ca74789bd6db565965382c982d06aae1c086097fa9c3e7c7d1eaf"
  license "LGPL-2.1-or-later"
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
    sha256 arm64_sequoia: "462f8b1b844ffd11a6848b3db96c9a91eb6d70b0293055375e83f29a2ae58c28"
    sha256 arm64_sonoma:  "cc5818a3b76aad42d8c8bb2353b1defc925f8fbf77aa9ca8da2fa4481a3b64f7"
    sha256 arm64_ventura: "c14286f2fad6a45db22b155b50311151628ab0c4626bf29222d3c8827dd72fca"
    sha256 sonoma:        "3b308c690e20b19c4bed0ffccfb4f5c9b75970ed631e445a664ab146bf7ac86b"
    sha256 ventura:       "9dd3822cccaefd5770675bf267f65ff6791b2869259bc98ad25f7633d55045af"
    sha256 x86_64_linux:  "9aa82a00506a9aad0a0bae6054d2eef6ec377eacfb8b0ff6f3416e66a6dac277"
  end

  keg_only "it conflicts with mariadb"

  depends_on "cmake" => :build
  depends_on "openssl@3"
  depends_on "zstd"

  uses_from_macos "curl"
  uses_from_macos "krb5"
  uses_from_macos "zlib"

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
