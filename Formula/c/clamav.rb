class Clamav < Formula
  desc "Anti-virus software"
  homepage "https://www.clamav.net/"
  url "https://github.com/Cisco-Talos/clamav/releases/download/clamav-1.4.3/clamav-1.4.3.tar.gz"
  mirror "https://www.clamav.net/downloads/production/clamav-1.4.3.tar.gz"
  sha256 "d874cabf3d4765b35b518ef535658a1e6ec74802006a1d613f9f124aa1343210"
  license "GPL-2.0-or-later"
  head "https://github.com/Cisco-Talos/clamav.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 arm64_sequoia: "251bf418c7dc47d360294ce30fdc3ff488999350856fd7d2b5389fb763563c3d"
    sha256 arm64_sonoma:  "527382622ca74f0c7e5510b14d76ba2f62dcf8eab59e557d4239d73c612520f8"
    sha256 arm64_ventura: "f67aac9831164aa14f229686286fb5e539b3d6628bd0b19531f93fcb933a04e1"
    sha256 sonoma:        "f87e21de03dd8e9f6d3d0f42f549c335096a990d716f6168a44f7d7f32095366"
    sha256 ventura:       "8a708db9eb56b97e584fe54d252eff885c26d1055cc82fc882351845e213def4"
    sha256 arm64_linux:   "e5a7e558c3d1120eb35c232371dfd79f3b63a2550ae17ef8ee875db8a64f43a0"
    sha256 x86_64_linux:  "87e9d72cfd741c30f3098924b2c1f27ff56205449fbac34847e72af11e181447"
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
