class Clamav < Formula
  desc "Anti-virus software"
  homepage "https://www.clamav.net/"
  url "https://github.com/Cisco-Talos/clamav/releases/download/clamav-1.1.0/clamav-1.1.0.tar.gz"
  mirror "https://www.clamav.net/downloads/production/clamav-1.1.0.tar.gz"
  sha256 "a30020d99cd467fa5ea0efbd6f4f182efebf62a9fc62fc4a3a7b2cc3f55e6b74"
  license "GPL-2.0-or-later"
  revision 1
  head "https://github.com/Cisco-Talos/clamav.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 arm64_ventura:  "9ae2e6e79a10ac3eb7d08d5386e9b8a99500d6a92909304b479c6c910374afd6"
    sha256 arm64_monterey: "efb65f1eb739aecd178693e7ed9e82d449a03648ac90bc78f3a77270c1c5d884"
    sha256 arm64_big_sur:  "e247eddf9a09fc2da4a2b7a335473d63204fcde035f095f001481757d8033764"
    sha256 ventura:        "1f4fad01de3a3663309ac8cc76eb18f242260c8f8e93b4984f01745c62af6eb7"
    sha256 monterey:       "b45c9d78705826e199fc4bb2e3e3aa96bb80011244380743c8c4484cd6c2a1b5"
    sha256 big_sur:        "39b20d42f011de92f8f230077bbe62fba5ffc0947563828f20805f7bb9502fd1"
    sha256 x86_64_linux:   "b44199d0e01d0c25c54dae2ebdc44a3eec9506adc55cfdd83c895b67fea3a1d8"
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
