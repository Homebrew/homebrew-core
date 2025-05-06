class MariadbConnectorC < Formula
  desc "MariaDB database connector for C applications"
  homepage "https://mariadb.org/download/?tab=connector&prod=connector-c"
  # TODO: Remove backward compatibility library symlinks on breaking version bump
  url "https://archive.mariadb.org/connector-c-3.4.5/mariadb-connector-c-3.4.5-src.tar.gz"
  mirror "https://fossies.org/linux/misc/mariadb-connector-c-3.4.5-src.tar.gz/"
  sha256 "b17e193816cb25c3364c2cc92a0ad3f1d0ad9f0f484dc76b8e7bdb5b50eac1a3"
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
    sha256 arm64_sequoia: "0f6e48401540ad5fca8583d02329792604df22c02a9137fec1ab02a4c1955756"
    sha256 arm64_sonoma:  "b96d0241b6244af7eca596aeb9d158c98d44d2e5f914023ca2ce8557ccbb5f77"
    sha256 arm64_ventura: "57809abf5e712cf20a0a5e1b9ea2f0f4c989b17b1e325aeff60d490e2c49cc3b"
    sha256 sonoma:        "7550489b9f9ad42c71427f97b2a9fc2fa1eecb4742b6ac6412b1cf4a9ed03fb6"
    sha256 ventura:       "17f76960fce3ba3b002d770da9a85eec2a5c97f01d00033db3a141d696047da2"
    sha256 arm64_linux:   "5166bacc7622caca103cbca8393791b1e61c840e7c0871337532ccbc2971bbce"
    sha256 x86_64_linux:  "12d8c56920e856f27a2adc9840590b6381e72c286c8bbb99579f45e2cc49671d"
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
