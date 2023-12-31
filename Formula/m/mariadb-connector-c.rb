class MariadbConnectorC < Formula
  desc "MariaDB database connector for C applications"
  homepage "https://mariadb.org/download/?tab=connector&prod=connector-c"
  url "https://archive.mariadb.org/connector-c-3.3.8/mariadb-connector-c-3.3.8-src.tar.gz"
  mirror "https://fossies.org/linux/misc/mariadb-connector-c-3.3.8-src.tar.gz/"
  sha256 "f9f076b4aa9fb22cc94b24f82c80f9ef063805ecd6533a2eb5d5060cf93833e8"
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
    sha256 arm64_sonoma:   "2e3f319f79f565a49b02a5f13cf362f714a468a91641420395b70e029255edb6"
    sha256 arm64_ventura:  "cffde9ada93358e535d0fb28ebc0488a59ba9f4c18febbb0c4ac622c55c87861"
    sha256 arm64_monterey: "26320f29ed7e7b9a59fdcd51a6d57d785e677718d0f3a25568bca5eabf1966fb"
    sha256 sonoma:         "a7067183c1da03b9f1ef885a02df2e8035e7cb415a30b687c526cb6a27e1dc93"
    sha256 ventura:        "a93312152888f8ef4d9305c6e4a991642da3276a6e137c9c30cb6030971d1cd3"
    sha256 monterey:       "3bd7f4c6ab89d8a234eab205b7e89d0ee0814aa84e37561d3cc36c548e4621a5"
    sha256 x86_64_linux:   "96d84fd6f80f496bb5e75cfcb596625fa6879b962034957822858b4161fadcd5"
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
