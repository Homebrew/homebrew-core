class Clamav < Formula
  desc "Anti-virus software"
  homepage "https://www.clamav.net/"
  url "https://github.com/Cisco-Talos/clamav/releases/download/clamav-1.2.0/clamav-1.2.0.tar.gz"
  mirror "https://www.clamav.net/downloads/production/clamav-1.2.0.tar.gz"
  sha256 "97a192dffe141480b56cabf1063d79a9fc55cd59203241fa41bfc7a98a548020"
  license "GPL-2.0-or-later"
  head "https://github.com/Cisco-Talos/clamav.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 arm64_ventura:  "fd638307f830a404756174db11191ba74f4fd8998d46dadde6e75cd78dc1b26c"
    sha256 arm64_monterey: "493f53d403bb2ef411f75c5536f4980f1a949272d52b107cdbe8424c18faa128"
    sha256 arm64_big_sur:  "61479084f9a8ebf52262db7da991fc176fd2ddbad091d3d67324b517b3a06e38"
    sha256 ventura:        "439057e74bc0ffe16c513e1498ff3fc753a370905c66d6163dddd8ed18316d5a"
    sha256 monterey:       "b539a9a4dbcbc7f8f992f739ac2142c7e5559620fb2d9e2070a54c9d69f3327d"
    sha256 big_sur:        "9dc3f5ac74f101656047fc9e2a8680a9dded50dfb7cba57ac82178060b7ba4e7"
    sha256 x86_64_linux:   "bb824d3ad1d8525327efc28379c0bbc7b7f42e074f8d245de9c6d0fed26ff888"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "json-c"
  depends_on "openssl@3"
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

  service do
    run [opt_sbin/"clamd", "--foreground"]
    keep_alive true
    require_root true
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
