class Clamav < Formula
  desc "Anti-virus software"
  homepage "https://www.clamav.net/"
  url "https://www.clamav.net/downloads/production/clamav-0.105.0.tar.gz"
  mirror "https://fossies.org/linux/misc/clamav-0.105.0.tar.gz"
  sha256 "270203a54c458049db54fcd93683ff5b2db19151f363c48e82cecefdde2b35d4"
  license "GPL-2.0-or-later"
  head "https://github.com/Cisco-Talos/clamav-devel.git", branch: "main"

  livecheck do
    url "https://www.clamav.net/downloads"
    regex(/href=.*?clamav[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_monterey: "79b91acbd865d0bf76674c385015e0af22337e45fd7c5841de1f93a1e842ebad"
    sha256 arm64_big_sur:  "62a16e224a6f63ef2c3bc5f3b208319501b92dc11aad9a60b7251001980525cd"
    sha256 monterey:       "77f29444d4ed6456de811a729613f3977cbfb1c714eee6e5def70aeff09ef240"
    sha256 big_sur:        "e71a1d20ea61d124b010f6467c835b95d5278b83d83ab5cc23214b0834007779"
    sha256 catalina:       "0fe9bdebb3ba0a4762fe2cf9129b328157390c3f84b7b3d8eb3b5a5d4a821d42"
    sha256 x86_64_linux:   "6f519799945f5557b0c455b66aaf44ae606ff08adb79559566f9c43cef6d82ae"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "rust" => :build
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
