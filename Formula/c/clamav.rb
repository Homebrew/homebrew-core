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
    rebuild 1
    sha256 arm64_tahoe:   "219df02b20bf1ab28fdc4a3b7b79708279992e921bcd40da94f90620e10b63b7"
    sha256 arm64_sequoia: "94b255fa171b5e92b99986dd9b9f17773aa27f13bc0056c6b945728506b6ce6b"
    sha256 arm64_sonoma:  "ddc866da4079b1cbccd104051c7d14d25f562a701e7d52c380b0d9f92191b7ff"
    sha256 sonoma:        "b16dae0e12c7c0eb591dd75a2b262dff9dc2f1e93d5f62702dde7c4df2f5531d"
    sha256 arm64_linux:   "2a910545e8050ba236ab3f1f5508b65b6a6f7daca9a2747ef304bd0b356663a3"
    sha256 x86_64_linux:  "c9ff6614ebc2303d4546762ac6801e0485d94249e2bdffeb142369c8d242d9c6"
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
      -DAPP_CONFIG_DIRECTORY=#{pkgetc}
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
      the example conf files at #{pkgetc}/
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
