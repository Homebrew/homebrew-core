class Clamav < Formula
  desc "Anti-virus software"
  homepage "https://www.clamav.net/"
  url "https://github.com/Cisco-Talos/clamav/releases/download/clamav-1.3.1/clamav-1.3.1.tar.gz"
  mirror "https://www.clamav.net/downloads/production/clamav-1.3.1.tar.gz"
  sha256 "12a3035bf26f55f71e3106a51a5fa8d7b744572df98a63920a9cff876a7dcce4"
  license "GPL-2.0-or-later"
  head "https://github.com/Cisco-Talos/clamav.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 arm64_sonoma:   "c100bcdb4014bfc8eca38d25187133ea66b56e44c0f60f75332dba54d0344983"
    sha256 arm64_ventura:  "f6e7759b7a57329b3123f5d31c191a0f33935efc602c44d8ec81744fb7d7ab7a"
    sha256 arm64_monterey: "dd0c6465cccfdf7cd9e469f83e92bf775d484f7d73ddc9f9ac78ac82990d1e2b"
    sha256 sonoma:         "9367c212601cedde4fecb12a61191c809a1233507b88b2bb324ad2bf0edc2783"
    sha256 ventura:        "72a0a82ba66888898ec33483ce358c3c9ce50830894b06af5cca324f17435bca"
    sha256 monterey:       "a0ed2b279b11cca181704908e7bc48ae061a7ba8f65e1c9e763814c1250a56d5"
    sha256 x86_64_linux:   "5de31abc876686bcc8043831b422dcebd6db40bda601f73ed4a7848ea708e116"
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
    system "#{bin}/freshclam", "--datadir=#{testpath}", "--config-file=#{testpath}/freshclam.conf"
    system "#{bin}/clamscan", "--database=#{testpath}", testpath
  end
end
