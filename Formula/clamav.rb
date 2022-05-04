class Clamav < Formula
  desc "Anti-virus software"
  homepage "https://www.clamav.net/"
  url "https://www.clamav.net/downloads/production/clamav-0.105.0.tar.gz"
  mirror "https://fossies.org/linux/misc/clamav-0.105.0.tar.gz"
  sha256 "270203a54c458049db54fcd93683ff5b2db19151f363c48e82cecefdde2b35d4"
  license "GPL-2.0-or-later"
  head "https://github.com/Cisco-Talos/clamav-devel.git", branch: "main"

  livecheck do
    url "https://www.clamav.net/downloads"
    regex(/href=.*?clamav[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_monterey: "c43a052726edfa7c985800fc95afd8187969d77cf6fdcf59f965ea31ce110dcd"
    sha256 arm64_big_sur:  "552fdb32234c8cc46b93167ed02fb78986867323311e2e493b77f1a73e3550a1"
    sha256 monterey:       "0c5fac6fcad12071daca1361ae441d649bf9f8bee0687de00e30d9eea2488d01"
    sha256 big_sur:        "60680060e34ccb855108cdcfd53406e61911c71390e7690471d4e6134bf36ed5"
    sha256 catalina:       "835cb8fc7bfb9dc71d40845cf349ec510e38a036d4c42b6813aa5aecb8b26f57"
    sha256 x86_64_linux:   "ed1e8f42bfd7b55888fea30f1d0f90f89716b9ecbd39e5917dd7630889a4796a"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "json-c"
  depends_on "libtool"
  depends_on "openssl@1.1"
  depends_on "pcre2"
  depends_on "yara"

  uses_from_macos "bzip2"
  uses_from_macos "curl"
  uses_from_macos "libxml2"
  uses_from_macos "ncurses"
  uses_from_macos "zlib"

  on_macos do
    depends_on "libiconv"
  end

  skip_clean "share/clamav"

  def install
    args = std_cmake_args + %W[
      -DAPP_CONFIG_DIRECTORY=#{etc}/clamav
      -DENABLE_JSON_SHARED=ON
      -DENABLE_STATIC_LIB=ON
      -DENABLE_SHARED_LIB=ON
      -DENABLE_EXAMPLES=OFF
      -DENABLE_TESTS=OFF
      -DENABLE_MILTER=OFF
    ]

    system "cmake", "-S", ".", "-B", "build", *args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  def caveats
    <<~EOS
      To finish installation & run clamav you will need to edit
      the example conf files at #{etc}/clamav/
    EOS
  end

  test do
    system "#{bin}/clamav-config", "--version"
    (testpath/"freshclam.conf").write <<~EOS
      DNSDatabaseInfo current.cvd.clamav.net
      DatabaseMirror database.clamav.net
    EOS
    system "#{bin}/freshclam", "--datadir=#{testpath}", "--config-file=#{testpath}/freshclam.conf"
    system "#{bin}/clamscan", "--database=#{testpath}", testpath
  end
end
