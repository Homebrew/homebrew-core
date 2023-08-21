class Clamav < Formula
  desc "Anti-virus software"
  homepage "https://www.clamav.net/"
  url "https://github.com/Cisco-Talos/clamav/releases/download/clamav-1.1.1/clamav-1.1.1.tar.gz"
  mirror "https://www.clamav.net/downloads/production/clamav-1.1.1.tar.gz"
  sha256 "a26699704bb4ddf2684e4adc1f46d5f3de9a9a8959f147970f969cc32b2f0d9e"
  license "GPL-2.0-or-later"
  head "https://github.com/Cisco-Talos/clamav.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 arm64_ventura:  "c3eea8531c13904fc7f06f467c1bb9976ff3f313049c2a464e6b171421b8b7a0"
    sha256 arm64_monterey: "b30d57db61cb273ab9e97de8e857245c77d5f315a9be2eaf1af811224af36b8f"
    sha256 arm64_big_sur:  "879dcb214f00b40b69aeec716321241393ef3e6f2bb38ffdcd26707943d8db2c"
    sha256 ventura:        "457960374c9a963ba2aacc1fdb75077029016f890e3acb3108e0e00799bb5628"
    sha256 monterey:       "96470aac5371404efc6b821598d8c02574338eccf2f653635a811569140b615a"
    sha256 big_sur:        "6fd8d9f7811c8ecc533f39a39f39886c6ad104a7f4586355b264d377ef0d980c"
    sha256 x86_64_linux:   "590f5f4ee40e645c84c67cc0ac3f1245051709076947669e45a257be4c522c1a"
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
