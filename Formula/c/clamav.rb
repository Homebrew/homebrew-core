class Clamav < Formula
  desc "Anti-virus software"
  homepage "https://www.clamav.net/"
  url "https://github.com/Cisco-Talos/clamav/releases/download/clamav-1.4.1/clamav-1.4.1.tar.gz"
  mirror "https://www.clamav.net/downloads/production/clamav-1.4.1.tar.gz"
  sha256 "a318e780ac39a6b3d6c46971382f96edde97ce48b8e361eb80e63415ed416ad8"
  license "GPL-2.0-or-later"
  head "https://github.com/Cisco-Talos/clamav.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 arm64_sequoia:  "735ca3297cb540df3fd811546931268748426b980ad1dbfb181ae2bc6619c743"
    sha256 arm64_sonoma:   "082646090205a5dde7f4acc9aabddf96d0bab2e2fa267558f7a03950066c5db0"
    sha256 arm64_ventura:  "4d06f08932594ea40a9cfeaa549882788bf58ddb1166fbf3216e94945ad68c54"
    sha256 arm64_monterey: "9aca3a2b0fe35c774976dc10c7e3ec6fce449781cd2f7ac5bc77db08c5f8bbd0"
    sha256 sonoma:         "0b841adeea58f249fbc4ba37abadd832551f63e9f2a8d40f3edc92555ed61af3"
    sha256 ventura:        "ae68a990d66f6d4bb85f8e2e7b78b8f6f1505e2f083448dd4779d7e1c8e899a4"
    sha256 monterey:       "60f5814cb36fe8c75eae0e5a56af261ab16652609bbb3dd142cc468252ed428d"
    sha256 x86_64_linux:   "7159d15800cd958ef4f474a4bc2309b79e32d186da765cb7f9a9d3d0be642ba2"
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

    system bin/"freshclam", "--datadir=#{testpath}", "--config-file=#{testpath}/freshclam.conf"
    system bin/"clamscan", "--database=#{testpath}", testpath
  end
end
