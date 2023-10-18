class MariadbConnectorC < Formula
  desc "MariaDB database connector for C applications"
  homepage "https://mariadb.org/download/?tab=connector&prod=connector-c"
  url "https://archive.mariadb.org/connector-c-3.3.7/mariadb-connector-c-3.3.7-src.tar.gz"
  mirror "https://fossies.org/linux/misc/mariadb-connector-c-3.3.7-src.tar.gz/"
  sha256 "975a9a862fed80f84e0206373f7ef05537aada5b65d99b71b36ab892b44240bf"
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
    sha256 arm64_sonoma:   "b3fd17ed00d02ee39413789b9467ec510fac207764b5600dfac1aec25ca3c4cc"
    sha256 arm64_ventura:  "9ad8814f5fd5d03c3a782be578e5082638c231a72a6f7d10a04cbf9bf22b35b5"
    sha256 arm64_monterey: "260368c40aa6a3102dbbfb6f69220ecd9c4c6a8098a5d00a46547b2b3d94bf0f"
    sha256 sonoma:         "5e836e44c11ac7b7784499c4c5efaac130d26957d5d12dbf62a1bfddbe6c12a2"
    sha256 ventura:        "c94065a0ed7331499c6ab8cfa14d8bba6c70362229a60cc4753b20066403f6d4"
    sha256 monterey:       "ae6c7e9deab5fba2d2966adeb015656c9707e7356d84623b3d5abce3f8f014b2"
    sha256 x86_64_linux:   "75ed6249b11a1aa1b6eb93161999484f8cc52eec4e602d0b0578bc7313c9a465"
  end

  depends_on "cmake" => :build
  depends_on "openssl@3"

  uses_from_macos "curl"
  uses_from_macos "zlib"

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
    system "#{bin}/mariadb_config", "--cflags"
  end
end
