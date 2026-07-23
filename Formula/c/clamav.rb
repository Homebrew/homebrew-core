class Clamav < Formula
  desc "Anti-virus software"
  homepage "https://www.clamav.net/"
  url "https://github.com/Cisco-Talos/clamav/releases/download/clamav-1.5.3/clamav-1.5.3.tar.gz"
  mirror "https://www.clamav.net/downloads/production/clamav-1.5.3.tar.gz"
  sha256 "89af57a45bbf13de4dc91ed7f20b435388c88428eb7dc30639a02b2f0fc2dad1"
  license "GPL-2.0-or-later"
  head "https://github.com/Cisco-Talos/clamav.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 arm64_tahoe:   "ceb7481a0e8af4a0e58946d84186a9607b8dce1115439edcd266144d0bdf27e5"
    sha256 arm64_sequoia: "3951ef39177fcf27f9634aa6fbe46b6da04ade6e0892bf8501969d268c3e5a29"
    sha256 arm64_sonoma:  "58083dd4b0aa88cd8363584adda06a977d448901b43ce0a2c332dc03f1237fb8"
    sha256 sonoma:        "ee7a53fe097ffcab20d4e0c6c9d0c75b67f1f6c8b411b905e0ea89f767fef94b"
    sha256 arm64_linux:   "3b0de86dc610802691e36f2349dd449b60fe27574d89b68f29e25b5ec275ec06"
    sha256 x86_64_linux:  "a4437d13c792e2fe04ae97f73cb8d23cb2a2adde031d897a2fa64aef566ffb2e"
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
