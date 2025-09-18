class MariadbConnectorC < Formula
  desc "MariaDB database connector for C applications"
  homepage "https://mariadb.org/download/?tab=connector&prod=connector-c"
  # TODO: Remove backward compatibility library symlinks on breaking version bump
  url "https://archive.mariadb.org/connector-c-3.4.7/mariadb-connector-c-3.4.7-src.tar.gz"
  mirror "https://fossies.org/linux/misc/mariadb-connector-c-3.4.7-src.tar.gz/"
  sha256 "33bb61168380af706b9e9531396cca223179ac2f9fe72edeae69e4546d7b7a2b"
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
    sha256 arm64_tahoe:   "424d8be26c7fb0a4fba870a96ef088fc83e1db63e788411ff9625f70316377bb"
    sha256 arm64_sequoia: "3b6dcf8daeab90e2b0ff613e2163de547888cf0e9b583bd38ed5a25bbd47b0c0"
    sha256 arm64_sonoma:  "896e95de6710581040796ee867ef46f7aa991cf523313967ad410165ce2d99c7"
    sha256 arm64_ventura: "85b078ccfc0abc357079770ba51a9e280dc23a205bdd84fa08bec2302ea0a421"
    sha256 sonoma:        "5c71069e766e65cf453337a1748e6973a724dd3f0cf570f719ec3e91550f1602"
    sha256 ventura:       "e6d4b11ab6ccd1b6b540c26f955f74c9386ad46aab3aa8458ab04cac5a56a7ac"
    sha256 arm64_linux:   "4fd4cf51b8dde34a44d07a054d748a42551de03ba47dc29e531c9b1538f65fa3"
    sha256 x86_64_linux:  "b3503f605fa35c4eb9d1c2765b050dc51a37fabccffcc3b44515a299fbb0ef35"
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
