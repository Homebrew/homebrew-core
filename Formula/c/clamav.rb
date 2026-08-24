class Clamav < Formula
  desc "Anti-virus software"
  homepage "https://www.clamav.net/"
  url "https://github.com/Cisco-Talos/clamav/releases/download/clamav-1.5.4/clamav-1.5.4.tar.gz"
  mirror "https://www.clamav.net/downloads/production/clamav-1.5.4.tar.gz"
  sha256 "1af1117a228f1b5bc7fa91a0dabc37848a99e7d25188e9be8043332ce721dfd3"
  license "GPL-2.0-or-later"
  head "https://github.com/Cisco-Talos/clamav.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 arm64_tahoe:   "f3d487c09435064df158bc3cac331c43543a9de9a71fb65add0cb7d65d71a0e4"
    sha256 arm64_sequoia: "526101fb67470ea38594bc7ac384ebda619e2a6a6b31de9d45068f8583f20bc3"
    sha256 arm64_sonoma:  "a95e3bd5dfe9a620c661e1a7bb14a7d0f2fd38ce7cb5050f3c6a37011c0083de"
    sha256 sonoma:        "89d4e47cf33d494249dbac96cf2ebd04af4ed186e9075d37eb336c22a62fb264"
    sha256 arm64_linux:   "7c5d9387f73105976d5dad78d6daa0b425da1b22d4b69c5ef2971af8e89a6edf"
    sha256 x86_64_linux:  "400ed20330f6cc5eb512e92475a7d204774ef48de9b7fef45af3187fd4d021a7"
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
