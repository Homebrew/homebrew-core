class Clamav < Formula
  desc "Anti-virus software"
  homepage "https://www.clamav.net/"
  url "https://github.com/Cisco-Talos/clamav/releases/download/clamav-1.4.0/clamav-1.4.0.tar.gz"
  mirror "https://www.clamav.net/downloads/production/clamav-1.4.0.tar.gz"
  sha256 "d67ab299e5ca05dad3da299a5ea73d60209372a5becd7f13b9a33c290338a4e6"
  license "GPL-2.0-or-later"
  head "https://github.com/Cisco-Talos/clamav.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 arm64_sonoma:   "867e8d51daabdf5c937d66f0e7b5ce735b37d3c7ec49258eae1a4c21ee42779f"
    sha256 arm64_ventura:  "fea4325cc6b4cf352d77a97811aed9748d55377a38fbaf37e1c6e0a3ca3813b0"
    sha256 arm64_monterey: "c8494f9c0ad5ac0479bf7f69a910bc08373b072babbda72ee153a0b34eb8414a"
    sha256 sonoma:         "94aecedb7856e532d50dde6da1f5274a8e9e350e3a2d0b27a3fedd83b03a1967"
    sha256 ventura:        "0a34742c336f7d0fe84290d26c04a472fd5b869da4e47f6947fba52b4c87ac3c"
    sha256 monterey:       "5ca75fc10106d7f2bc67df49dc16708eb3cdd7c1fc62d75647393e209bf81060"
    sha256 x86_64_linux:   "8b8befd2218ed485c7e9ea40a3769c05d750e862a258adc5a007f9a12db1bb89"
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

    system bin/"freshclam", "--datadir=#{testpath}", "--config-file=#{testpath}/freshclam.conf"
    system bin/"clamscan", "--database=#{testpath}", testpath
  end
end
