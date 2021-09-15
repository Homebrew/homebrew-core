class Clamav < Formula
  desc "Anti-virus software"
  homepage "https://www.clamav.net/"
  url "https://www.clamav.net/downloads/production/clamav-0.104.0.tar.gz"
  mirror "https://fossies.org/linux/misc/clamav-0.104.0.tar.gz"
  sha256 "a079d64cd55d6184510adfe0f341b2f278f7fb1bcc080d28d374298160f19cb2"
  license "GPL-2.0-or-later"
  revision 1
  head "https://github.com/Cisco-Talos/clamav-devel.git", branch: "main"

  livecheck do
    url "https://www.clamav.net/downloads"
    regex(/href=.*?clamav[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_big_sur: "a56bdeb2b36da5c13d88cf56ae78f72a0ce03150a50afe02c374bb62bdb85b46"
    sha256 big_sur:       "2b84fa9ddb9150cbd0affd0d07fbafc8460f42354b0e4b9a7f83ea120dc62f60"
    sha256 catalina:      "8a9d8cb97ebb5fd9986cf087dbbebd6c78ba2dcff76ba0778e16abf4bf82c6df"
    sha256 mojave:        "517e16b12c8c467758781e2b3ddd17fe20cbe134fc51f837a3e651e212821a8b"
    sha256 x86_64_linux:  "11c421762b425034eb4e1c8cf3307ecd4867a626c5c6971c91c8a9a04a0fc22d"
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
