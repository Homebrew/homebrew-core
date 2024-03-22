class Clamav < Formula
  desc "Anti-virus software"
  homepage "https://www.clamav.net/"
  url "https://github.com/Cisco-Talos/clamav/releases/download/clamav-1.3.0/clamav-1.3.0.tar.gz"
  mirror "https://www.clamav.net/downloads/production/clamav-1.3.0.tar.gz"
  sha256 "0a86a6496320d91576037b33101119af6fd8d5b91060cd316a3a9c229e9604aa"
  license "GPL-2.0-or-later"
  head "https://github.com/Cisco-Talos/clamav.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 arm64_sonoma:   "b82c02d3b3965d924e4d28bbddeff6aea8f365beae15f052a0ea23b7dd6e019c"
    sha256 arm64_ventura:  "8c001b2b1ac6b1622c59d26da75ddd50f5ac71ac21289dfc472b2b8f2ce2d545"
    sha256 arm64_monterey: "1827315b489bf48a99803f01dab47aa87a74e65ec8bff66371bef561386be864"
    sha256 sonoma:         "ec610703603d1393ff95574e5548d8047046c90921bcf4545af0eca171c2bb4e"
    sha256 ventura:        "78e0a282d0c42ccf8afc0f70e7462fccc02f66ec21d76e47589c459b51eda3a8"
    sha256 monterey:       "0429d15a691d8c05c934d8db1cc089264111a607589c04f9cfd802b244f2f790"
    sha256 x86_64_linux:   "4a15884a204451842473338b46e6f9141a64415a9819b4822194cd39e1cd6c49"
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
