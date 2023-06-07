class Clamav < Formula
  desc "Anti-virus software"
  homepage "https://www.clamav.net/"
  url "https://www.clamav.net/downloads/production/clamav-1.1.0.tar.gz"
  mirror "https://fossies.org/linux/misc/clamav-1.1.0.tar.gz"
  sha256 "a30020d99cd467fa5ea0efbd6f4f182efebf62a9fc62fc4a3a7b2cc3f55e6b74"
  license "GPL-2.0-or-later"
  head "https://github.com/Cisco-Talos/clamav-devel.git", branch: "main"

  livecheck do
    url "https://www.clamav.net/downloads"
    regex(/href=.*?clamav[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_ventura:  "8927fbb21915aec3cd3eac32a43af1d6192811e27ecc1b5bbbb04256917fd13f"
    sha256 arm64_monterey: "5030360c38eeaa22c37b4eb18b4de60469f152208d608230281a9d13b07abd8e"
    sha256 arm64_big_sur:  "9db7eb15021e5cebda5cfe6c96011030ee254c0a1171e54c8896dbc03b7edb96"
    sha256 ventura:        "03a3f6297a60233b5e094472e33e0532d27048742bc8a006dbbbc371eed80993"
    sha256 monterey:       "04edd920c0a672a4c8f15b8265dcf25a4e2d05a8fff01dbba40465dfdece9669"
    sha256 big_sur:        "00630322cf6bd096f280dfbf629f8888e60453113b8f50d0c380afbad5e5e626"
    sha256 x86_64_linux:   "25e55ff251c13ad5cac8f8eadc4e6190920af91606697f7ed46083d50e8fa9b0"
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
