class MariadbConnectorC < Formula
  desc "MariaDB database connector for C applications"
  homepage "https://mariadb.org/download/?tab=connector&prod=connector-c"
  # TODO: Remove backward compatibility library symlinks on breaking version bump
  url "https://archive.mariadb.org/connector-c-3.4.8/mariadb-connector-c-3.4.8-src.tar.gz"
  mirror "https://fossies.org/linux/misc/mariadb-connector-c-3.4.8-src.tar.gz/"
  sha256 "156aed3b49f857d0ac74fb76f1982968bcbfd8382da3f5b6ae71f616729920d7"
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
    sha256 arm64_tahoe:   "e6a0bbb96d47363e4a7f5e06879e1578865c8ef43bcf1a44a6116d7d3a22f9e8"
    sha256 arm64_sequoia: "5d6a83ad23b28075bcb4396f9c551eea46a2eb41319b971d5753940248168e40"
    sha256 arm64_sonoma:  "c4ead6e03193044e0848aebb0ead7e37e0d212358e2233c405e669aae61402c6"
    sha256 sonoma:        "6eab78fa3a278544397565e6a6264ea6113bd1cdd76277cd9422f1ae486a7ac5"
    sha256 arm64_linux:   "cb30c78a233c4ce73cd6d7858276b1a11eaa3c46ff00330f5da423a4d02af6d6"
    sha256 x86_64_linux:  "b0756f514abf577ac92f2b6bf9c0919d590373b6bf52e62e07c9deca64554d56"
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
