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
    sha256 arm64_monterey: "6c9e5236fd4fc487e5c38df622694a334e8c5d176d56947ba87e17c4af18d92d"
    sha256 arm64_big_sur:  "81fca3d2d734d723b269167c5624383612f53a1317d7f02e09f9a2ca7672b47d"
    sha256 monterey:       "ebc6f714302bfc91b7f068e3558b2f1593c6fba7d96cd81e00df38a97e7deeb7"
    sha256 big_sur:        "ee05ec3fc098bc5ad4ab216cc575ca35c117cc2b933e1b5ed570164074fd7f53"
    sha256 catalina:       "b29973a04291285d23c984f59173276396b63de709b8ba69986ccf437ee46942"
    sha256 x86_64_linux:   "63943c5d3d97b86635fb6ae095d2897591d05a1d599da583175d4b2eb84da343"
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
