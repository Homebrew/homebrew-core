class Clamav < Formula
  desc "Anti-virus software"
  homepage "https://www.clamav.net/"
  url "https://www.clamav.net/downloads/production/clamav-1.0.1.tar.gz"
  mirror "https://fossies.org/linux/misc/clamav-1.0.1.tar.gz"
  sha256 "0872dc1b82ff4cd7e8e4323faf5ee41a1f66ae80865d05429085b946355d86ee"
  license "GPL-2.0-or-later"
  head "https://github.com/Cisco-Talos/clamav-devel.git", branch: "main"

  livecheck do
    url "https://www.clamav.net/downloads"
    regex(/href=.*?clamav[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 arm64_ventura:  "20fa54f0363b44b41f510d1165b14235518ade3cb015c9cb6132e48b812d1558"
    sha256 arm64_monterey: "5036a85ef01d1e0292dc593c91ddb62ff2841d3b7c350cb1206eb15d34b044b2"
    sha256 arm64_big_sur:  "7befdfea6d7ddb3a554e17d7e5751f20ecd9ab1fa010b399227cc7cfdd574dcb"
    sha256 ventura:        "015f15cc18655b931dc8b31f854ced4aea0b56b552366a8fb6724b162db753f6"
    sha256 monterey:       "3db9d5acd15c9f509ca1e11b9a805c45df1b5685190d6f39875dcc5b5a25629d"
    sha256 big_sur:        "ae9ab4abe64d93199fae2ea4a47c48496d2e69df5d4040e368879edba35c2402"
    sha256 x86_64_linux:   "8b2a6fb3a8caaa5121067e025fabb91603254370ea75bcb19c22f2a10c68df1d"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "json-c"
  depends_on "openssl@1.1"
  depends_on "pcre2"
  depends_on "yara"

  uses_from_macos "bzip2"
  uses_from_macos "curl"
  uses_from_macos "libxml2"
  uses_from_macos "ncurses"
  uses_from_macos "zlib"

  skip_clean "share/clamav"

  def install
    args = %W[
      -DAPP_CONFIG_DIRECTORY=#{etc}/clamav
      -DDATABASE_DIRECTORY=#{var}/lib/clamav
      -DENABLE_JSON_SHARED=ON
      -DENABLE_STATIC_LIB=ON
      -DENABLE_SHARED_LIB=ON
      -DENABLE_EXAMPLES=OFF
      -DENABLE_TESTS=OFF
      -DENABLE_MILTER=OFF
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  def post_install
    (var/"lib/clamav").mkpath
  end

  def caveats
    <<~EOS
      To finish installation & run clamav you will need to edit
      the example conf files at #{etc}/clamav/
    EOS
  end

  test do
    assert_match "Database directory: #{var}/lib/clamav", shell_output("#{bin}/clamconf")
    (testpath/"freshclam.conf").write <<~EOS
      DNSDatabaseInfo current.cvd.clamav.net
      DatabaseMirror database.clamav.net
    EOS
    system "#{bin}/freshclam", "--datadir=#{testpath}", "--config-file=#{testpath}/freshclam.conf"
    system "#{bin}/clamscan", "--database=#{testpath}", testpath
  end
end
