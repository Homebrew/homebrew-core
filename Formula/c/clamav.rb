class Clamav < Formula
  desc "Anti-virus software"
  homepage "https://www.clamav.net/"
  url "https://github.com/Cisco-Talos/clamav/releases/download/clamav-1.4.2/clamav-1.4.2.tar.gz"
  mirror "https://www.clamav.net/downloads/production/clamav-1.4.2.tar.gz"
  sha256 "8c92f8ade2a8f2c9d6688d1d63ee57f6caf965d74dce06d0971c6709c8e6c04c"
  license "GPL-2.0-or-later"
  head "https://github.com/Cisco-Talos/clamav.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 arm64_sequoia: "4905fe4fabf8a82b668f3459579bbe866411e11e40b67186954e4e04a3bf24d3"
    sha256 arm64_sonoma:  "57e3cb64b82dbdbed45b7ca09772d0386a8d87d0841805af72e18ee2b10092dd"
    sha256 arm64_ventura: "0d04eec631abc4cefba76b84d0ff19370e9cd9784f5d02e9eeceb06f92aae4c5"
    sha256 sonoma:        "555d9306b8715927159cd870985253cd1ca04b6c1e4ecea7bf189edafbe21ec4"
    sha256 ventura:       "538e09f3f9d312667e9f8fc75092f7a66e4776cdd329941787d1101b15761b38"
    sha256 arm64_linux:   "67030a88aa5aba70d7aa0d5026a18e6d8f7c8696178fbdd15c35a92190bf828d"
    sha256 x86_64_linux:  "94b058838c51f394fbe71a74bb68a77b6e5f50909f7d34c7419b48a233dea6eb"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
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

    system bin/"freshclam", "--datadir=#{testpath}", "--config-file=#{testpath}/freshclam.conf"
    system bin/"clamscan", "--database=#{testpath}", testpath
  end
end
