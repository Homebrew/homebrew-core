class Nzbget < Formula
  desc "Binary newsgrabber for nzb files"
  homepage "https://nzbget.com"
  url "https://github.com/nzbgetcom/nzbget/archive/refs/tags/v24.5.tar.gz"
  sha256 "d8a26fef9f92d63258251c69af01f39073a479e48c14114dc96d285470312c83"
  license "GPL-2.0-or-later"
  revision 1
  head "https://github.com/nzbgetcom/nzbget.git", branch: "develop"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "cfb625c14570f9ad326f3f92b01383473c94fadedb324f6b51d5f8e58a573558"
    sha256 cellar: :any,                 arm64_sonoma:  "9a79e5a56c6e0e176711be00a643789561d3422b91adc6f62c013785bb0f54e7"
    sha256 cellar: :any,                 arm64_ventura: "13ef54d1cb4b17fb7cb91e0fdfa82297c455cd1dd01c63d03fdf385347aaf732"
    sha256                               sonoma:        "54cf30d56515995e3b417af8927f889b8f8406352ee4c8e302d2e1bfbcb7d73d"
    sha256                               ventura:       "d6c9ffebed9e93a4b14480f0ed02fee96da6a6ccdd6df7892d3ccdcbbe1afe96"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0038ebe43a06bf603373d93f7d83fcf43504fa81682cad9b63e370935f993fc7"
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
