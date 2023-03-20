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
    sha256 arm64_ventura:  "85f823c7b499aa384518d0b6334f3467986122fa54c54b7229c81dd29760dee4"
    sha256 arm64_monterey: "70a895a3984c863774fead0ab8303eef02ded24f8093e7254060c8b168462569"
    sha256 arm64_big_sur:  "39f11c71b2cb81ac5d399355d269ded246010ebc441ac612e168da170836b20c"
    sha256 ventura:        "63187f773ae19370c6156fc3dc95977affa416a008808e5a1e3f62a6a242eabe"
    sha256 monterey:       "a0d875182ed930635b340bbc4676c93a03fec4423168a94710b0f31ad7b9c27f"
    sha256 big_sur:        "20a730b23d1f68be2d6533cdb29fde3816db76a503651b0685fc0905a9384fd6"
    sha256 x86_64_linux:   "e29f8408cee6ea3d2c0aab1a2795086cdac4a2713f0baccb865654f4fa95cca7"
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
