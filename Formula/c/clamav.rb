class Clamav < Formula
  desc "Anti-virus software"
  homepage "https://www.clamav.net/"
  url "https://github.com/Cisco-Talos/clamav/releases/download/clamav-1.5.5/clamav-1.5.5.tar.gz"
  mirror "https://www.clamav.net/downloads/production/clamav-1.5.5.tar.gz"
  sha256 "90284644e5568732c15fc4f4312fd0f09ac14c14e5b29fba3909d4da4e281b1e"
  license "GPL-2.0-or-later"
  head "https://github.com/Cisco-Talos/clamav.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    manifest_sha256 "d2505e82cca7d31166c5ac765dd7c6e43d32c514715d98fc7d9821db170f5516"
    sha256 arm64_golden_gate: "958f1c4c51927e16af8ee4f3491ea78a7161b1c2f87e591a472dac8fdd229645"
    sha256 arm64_tahoe:       "3edafc36846380214af4cdd53d5cb2261693d23c21036f2ce3743924d2eb463d"
    sha256 arm64_sequoia:     "8125c58997ee415d8719bb46deed07648e8b4a72f836459d439efdfa86c6f77d"
    sha256 arm64_linux:       "736bd3c891f0eb1c1b342222a9cc96853e96809d900a625d8bae28e5b2f5ba98"
    sha256 x86_64_linux:      "c1b25a778df04c28325815c63c3e6147f7dec5d0a547af60e78e721b2d9e7929"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "json-c"
  depends_on "openssl@4"
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

  allow_network_access! :test

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
    (testpath/"freshclam.conf").write <<~EOS
      DNSDatabaseInfo current.cvd.clamav.net
      DatabaseMirror database.clamav.net
    EOS

    system bin/"freshclam", "--datadir=#{testpath}", "--config-file=#{testpath}/freshclam.conf"
    system bin/"clamscan", "--database=#{testpath}", testpath
  end
end
