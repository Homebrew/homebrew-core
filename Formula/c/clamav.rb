class Clamav < Formula
  desc "Anti-virus software"
  homepage "https://www.clamav.net/"
  url "https://github.com/Cisco-Talos/clamav/releases/download/clamav-1.5.1/clamav-1.5.1.tar.gz"
  mirror "https://www.clamav.net/downloads/production/clamav-1.5.1.tar.gz"
  sha256 "64fe4a16a5622c1d71efe9ed7f2c2fbd37f8f237da9f11ff66b73038df71db91"
  license "GPL-2.0-or-later"
  revision 1
  head "https://github.com/Cisco-Talos/clamav.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 arm64_tahoe:   "1d8bfd2ecb4104a16db37182c3d4a3ff88bdf3b1c36c1cba1c0b88ce6122ab98"
    sha256 arm64_sequoia: "c009af8083d6235331d389f17890c585ab30e45282b18f6d5730ab42b9b5a18c"
    sha256 arm64_sonoma:  "4bfda2af646d967128cb2f4a83f03e57a3bb3a5858c74f0ece82122e18c7c209"
    sha256 sonoma:        "d15aa15590dad8d82f7ef1b0c6e2a770d8fe6663e3579d3d544010fb5d56d34e"
    sha256 arm64_linux:   "f9e10712b361e5a55066a4efd66579c033ec74fd2a69bea2e546f3087bbccf9d"
    sha256 x86_64_linux:  "0f816d671608aa0b586e991b5b713b20679f17b3e88edfe4cae8916a51226894"
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
