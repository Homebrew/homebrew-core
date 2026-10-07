class MariadbConnectorC < Formula
  desc "MariaDB database connector for C applications"
  homepage "https://mariadb.org/download/?tab=connector&prod=connector-c"
  # TODO: Remove backward compatibility library symlinks on breaking version bump
  url "https://archive.mariadb.org/connector-c-3.4.11/mariadb-connector-c-3.4.11-src.tar.gz"
  mirror "https://fossies.org/linux/misc/mariadb-connector-c-3.4.11-src.tar.gz/"
  sha256 "521c0712e9291fa96558df9e2ff431376a3a79329f13751896b694cae12765b4"
  license "LGPL-2.1-or-later"
  revision 1
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
    sha256 arm64_golden_gate: "6fcfebff6530c45deb26ebb70784698c02b01d277945f693a9e926575c74d3a1"
    sha256 arm64_tahoe:       "420a7f7768d49a5c93f47d2a184ceb866fd9df9a33458978c4c78b6397f0b1c1"
    sha256 arm64_sequoia:     "d67e937637051081cf1be657990a4fadb6f37fc97faf507312c77e30b673d069"
    sha256 arm64_linux:       "f16858bc8708e73328f82ca24b1df8b9dd4b31d19b93345ad601ac9b11207979"
    sha256 x86_64_linux:      "b28e7b5c7b9e7f34b6565f390460618432798ff4443eb537c52b8efacc13221c"
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
