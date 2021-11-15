class Clamav < Formula
  desc "Anti-virus software"
  homepage "https://www.clamav.net/"
  url "https://www.clamav.net/downloads/production/clamav-0.104.1.tar.gz"
  mirror "https://fossies.org/linux/misc/clamav-0.104.1.tar.gz"
  sha256 "b7e6b709ab6c8a8eddb8c32b04c3e5df38adcae459b4ecd9bc1febaca9be57c0"
  license "GPL-2.0-or-later"
  head "https://github.com/Cisco-Talos/clamav-devel.git", branch: "main"

  livecheck do
    url "https://www.clamav.net/downloads"
    regex(/href=.*?clamav[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_monterey: "414f077061d6ef76d11af9d4bc5380cea125ccd2f00c2479367856b587df50c9"
    sha256 arm64_big_sur:  "0f48e171c14771e049e9217308fafc1066d481c05bc730d94d34d540a10f4b13"
    sha256 monterey:       "03ca4a7b0e05a6f27c297e886bb633d9e7bb7b74a843851de555731ca667eeaf"
    sha256 big_sur:        "53f8691e3afa31188f1e237576e6c11b74f9fd220c7c80e0d8cadb72c0d1c609"
    sha256 catalina:       "ea7fe519230ed6e685833979038891bbe23e7e0574ec0afb0da284ded05a0f8a"
    sha256 x86_64_linux:   "a545f4bc983f1a2992751bc62c9651fdf9ce1a930b3a446851b1f8d7122f4dad"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "json-c"
  depends_on "libtool"
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
    system "#{bin}/clamav-config", "--version"
    (testpath/"freshclam.conf").write <<~EOS
      DNSDatabaseInfo current.cvd.clamav.net
      DatabaseMirror database.clamav.net
    EOS
    system "#{bin}/freshclam", "--datadir=#{testpath}", "--config-file=#{testpath}/freshclam.conf"
    system "#{bin}/clamscan", "--database=#{testpath}", testpath
  end
end
