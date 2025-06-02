class Nzbget < Formula
  desc "Binary newsgrabber for nzb files"
  homepage "https://nzbget.com"
  url "https://github.com/nzbgetcom/nzbget/archive/refs/tags/v25.0.tar.gz"
  sha256 "104ebd7b0abed02ae11e968073063df27b0b39d4b62170e5785103a9a10d9999"
  license "GPL-2.0-or-later"
  head "https://github.com/nzbgetcom/nzbget.git", branch: "develop"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "371d055797f59c911e6be17f10eb42112abe701114f5d8f60a4855048ff26d67"
    sha256 cellar: :any,                 arm64_sonoma:  "8909eb1f6343e497a84b8978669471eb422449b8474ce1022fe620a68a09a9fa"
    sha256 cellar: :any,                 arm64_ventura: "de057a02a644af8dad13c30511d71bd24c9c73be018c4119587e99a1439ca432"
    sha256                               sonoma:        "6d6a39e4990d42f45c927d09138167d5aef5f24f60e8e541f3807bc60e02aea5"
    sha256                               ventura:       "816f3371545857cadd216e2c3b102ec28ccc5ff63311a514025354a94723f50b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8e88197900adac0cfc6bb08322ac67cac5626dd00cea49080351d8067dd1b73b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ec23d3eb13a1763e72658adb7e4a2ef20c802771491e86cc8fea7e70eb6aa366"
  end

  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "openssl@3"
  depends_on "sevenzip"

  uses_from_macos "libxml2"
  uses_from_macos "ncurses"
  uses_from_macos "zlib"

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    if OS.mac?
      # Set upstream's recommended values for file systems without
      # sparse-file support (e.g., HFS+); see Homebrew/homebrew-core#972
      inreplace "nzbget.conf", "DirectWrite=yes", "DirectWrite=no"
      inreplace "nzbget.conf", "ArticleCache=0", "ArticleCache=700"
      # Update 7z cmd to match homebrew binary
      inreplace "nzbget.conf", "SevenZipCmd=7z", "SevenZipCmd=7zz"
    end

    etc.install "nzbget.conf"
  end

  service do
    run [opt_bin/"nzbget", "-c", HOMEBREW_PREFIX/"etc/nzbget.conf", "-s", "-o", "OutputMode=Log",
         "-o", "ConfigTemplate=#{HOMEBREW_PREFIX}/share/nzbget/nzbget.conf",
         "-o", "WebDir=#{HOMEBREW_PREFIX}/share/nzbget/webui"]
    keep_alive true
    environment_variables PATH: "#{HOMEBREW_PREFIX}/bin:/usr/bin:/bin:/usr/sbin:/sbin"
  end

  test do
    (testpath/"downloads/dst").mkpath
    # Start nzbget as a server in daemon-mode
    system bin/"nzbget", "-D", "-c", etc/"nzbget.conf"
    # Query server for version information
    system bin/"nzbget", "-V", "-c", etc/"nzbget.conf"
    # Shutdown server daemon
    system bin/"nzbget", "-Q", "-c", etc/"nzbget.conf"
  end
end
