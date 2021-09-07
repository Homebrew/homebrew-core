class Clamav < Formula
  desc "Anti-virus software"
  homepage "https://www.clamav.net/"
  url "https://www.clamav.net/downloads/production/clamav-0.104.0.tar.gz"
  mirror "https://fossies.org/linux/misc/clamav-0.104.0.tar.gz"
  sha256 "a079d64cd55d6184510adfe0f341b2f278f7fb1bcc080d28d374298160f19cb2"
  license "GPL-2.0-or-later"
  head "https://github.com/Cisco-Talos/clamav-devel.git", branch: "main"

  livecheck do
    url "https://www.clamav.net/downloads"
    regex(/href=.*?clamav[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_big_sur: "0a23a5fc1c7121ce43aade26688cd0e6cb55444c95c2a3037f485150919eabc8"
    sha256 big_sur:       "f4f979fb914bd3f341b45f30335af9909b7a3c13339001e9e8ec943b4f11e008"
    sha256 catalina:      "44bdc057c16215b4d386581b22c6068e3b95c3e7282ffc977ac9d670da029f98"
    sha256 mojave:        "a269e7501d297f303441b3739db9f35f548e410dfb499f19719133b2e69264e5"
    sha256 x86_64_linux:  "e1b469d39a7dd51c235684ac4e4f2c3562e862d16bc396108ff2140e88343d72"
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
  uses_from_macos "zlib"

  on_macos do
    depends_on "libiconv"
  end

  skip_clean "share/clamav"

  def install
    args = std_cmake_args + %w[
      -DENABLE_JSON_SHARED=ON
      -DENABLE_STATIC_LIB=ON
      -DENABLE_SHARED_LIB=ON
      -DENABLE_EXAMPLES=OFF
      -DENABLE_TESTS=OFF
    ]

    args << "-DENABLE_MILTER=OFF" if OS.linux?

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
