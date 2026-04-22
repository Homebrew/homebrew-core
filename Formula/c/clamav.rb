class Clamav < Formula
  desc "Anti-virus software"
  homepage "https://www.clamav.net/"
  url "https://github.com/Cisco-Talos/clamav/releases/download/clamav-1.5.2/clamav-1.5.2.tar.gz"
  mirror "https://www.clamav.net/downloads/production/clamav-1.5.2.tar.gz"
  sha256 "f34018cf22f05bdd9d1a1574ca07193e3e030ca52050c3e5c220e23a32314965"
  license "GPL-2.0-or-later"
  head "https://github.com/Cisco-Talos/clamav.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 arm64_tahoe:   "da2ff01e94f58f60ccc44ef66cc0c20c4b05150352789c041617daedc2180d7b"
    sha256 arm64_sequoia: "8dc570e59cc547273a807e746cecc6cbe3551c77080cf727afcb49180cec42c9"
    sha256 arm64_sonoma:  "6de5dc85434b920bf96a2ecb0738025499bf6e9b0dd4f237de6926786d302195"
    sha256 sonoma:        "e93c879894036a2e2ce2992e59dd3a03bac19bd37a6ff10120e1d273f36385c7"
    sha256 arm64_linux:   "95a1bedac2b683a30b354406b4ddbe6c465965446fc134d8699ceeab98374f71"
    sha256 x86_64_linux:  "f57a456f57e5d758a01c7ffc075a661e70cbb35e46eed22f4d17f44982c555fe"
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

  on_linux do
    depends_on "zlib-ng-compat"
  end

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
