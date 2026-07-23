class MariadbConnectorC < Formula
  desc "MariaDB database connector for C applications"
  homepage "https://mariadb.org/download/?tab=connector&prod=connector-c"
  # TODO: Remove backward compatibility library symlinks on breaking version bump
  url "https://archive.mariadb.org/connector-c-3.4.9/mariadb-connector-c-3.4.9-src.tar.gz"
  mirror "https://fossies.org/linux/misc/mariadb-connector-c-3.4.9-src.tar.gz/"
  sha256 "a84bba97e59b6a322637a189964d4fd72bd8d92f2d22a9f8d6a5f0657c821e97"
  license "LGPL-2.1-or-later"
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
    sha256 arm64_tahoe:   "45d46ce8efcd4090429cc070975f7d93a87204d9bc466caaa040dadcfb59595f"
    sha256 arm64_sequoia: "9c081cecb6d0929f1ccd9c0d22a8ab66bbc211ecb1fe2f4193d9f4b6927979b2"
    sha256 arm64_sonoma:  "d5d8b435dc880722432a7a1518e095233c638ff1a7a22399a08f9791d901896f"
    sha256 sonoma:        "75ba826c6f9ae85bab7646e590071dea4cdd977a56704dd8cc90f6873648b1ab"
    sha256 arm64_linux:   "5fe111f3b848bae6b6a3a9894d49da74bb04c1e85719b2e9f3369995c36d38a2"
    sha256 x86_64_linux:  "d9c0927b765ea810e1ed4525154dc78a93eca791e85c3e8cd72195334225e6b0"
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
