class Clamav < Formula
  desc "Anti-virus software"
  homepage "https://www.clamav.net/"
  url "https://www.clamav.net/downloads/production/clamav-0.105.1.tar.gz"
  mirror "https://fossies.org/linux/misc/clamav-0.105.1.tar.gz"
  sha256 "d2bc16374db889a6e5a6ac40f8c6e700254a039acaa536885a09eeea4b8529f6"
  license "GPL-2.0-or-later"
  revision 1
  head "https://github.com/Cisco-Talos/clamav-devel.git", branch: "main"

  livecheck do
    url "https://www.clamav.net/downloads"
    regex(/href=.*?clamav[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_monterey: "17bdce90d972244e322899200109657442978e7c25df8e8b2d9d30981a9dde20"
    sha256 arm64_big_sur:  "bf78ede987750a3c358a28fc33a882b4285eb133d821c712ecf00d2bd7fc5095"
    sha256 monterey:       "7f7207e5a902289cbce8f898226ee64ac630c1ad6000139fa45c78fbd25be2d8"
    sha256 big_sur:        "8405dde8059d027a82fc49aa5fa03570c18496d81a3c0dc0788f8fe7d600c3a6"
    sha256 catalina:       "8b671db52fb8eee93e031f7fa4b787fd3deda60a05235689aefd0eb54346d778"
    sha256 x86_64_linux:   "56ae6a3c76325a8585125f79c63bb37473bdadb5592fe24d06b0abe03c60977c"
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

  on_macos do
    depends_on "libiconv"
  end

  skip_clean "share/clamav"

  def install
    args = std_cmake_args + %W[
      -DAPP_CONFIG_DIRECTORY=#{etc}/clamav
      -DDATABASE_DIRECTORY=#{var}/lib/clamav
      -DENABLE_JSON_SHARED=ON
      -DENABLE_STATIC_LIB=ON
      -DENABLE_SHARED_LIB=ON
      -DENABLE_EXAMPLES=OFF
      -DENABLE_TESTS=OFF
      -DENABLE_MILTER=OFF
    ]

    system "cmake", "-S", ".", "-B", "build", *args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
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
