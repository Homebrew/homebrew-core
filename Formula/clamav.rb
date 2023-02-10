class Clamav < Formula
  desc "Anti-virus software"
  homepage "https://www.clamav.net/"
  url "https://www.clamav.net/downloads/production/clamav-1.0.0.tar.gz"
  mirror "https://fossies.org/linux/misc/clamav-1.0.0.tar.gz"
  sha256 "bda39bb856902e6dd6077ea313a3eb8beccd487e0082a95917877f2b299cd86e"
  license "GPL-2.0-or-later"
  head "https://github.com/Cisco-Talos/clamav-devel.git", branch: "main"

  livecheck do
    url "https://www.clamav.net/downloads"
    regex(/href=.*?clamav[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_ventura:  "566a4d11bc8ca53fee33d293affe50755cf2319c4b512b8f70602da28885d6bc"
    sha256 arm64_monterey: "21f3be13579c7c6d727e14cb63cb8d63596303b69e9a568e4c91989e4d02661e"
    sha256 arm64_big_sur:  "7d66556ccb979501639455ca4539a9363125e6dba7870adcc4b0fbdc66f84f1a"
    sha256 ventura:        "f0077180b720016af25f6a5e7b30a850452dd53ee5a3cbd262b8f91da2972291"
    sha256 monterey:       "74b61ebb8712d8ebd61ef91e84985189a63fcc4566d1d56d3c2186def0a25fc1"
    sha256 big_sur:        "c69381ac4b0291b822b865a81111eb70c50994377fc8d3ce01ab778b23bd5405"
    sha256 catalina:       "7c43f41dea9dbaeaa7090a88657f830464b8fde34965301e4fa95651f6a6cbb4"
    sha256 x86_64_linux:   "23b2c1b89b53a2bec4acc6c43b3194bec144be7c220be6a58da8f9acf197508c"
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
