class Nzbget < Formula
  desc "Binary newsgrabber for nzb files"
  homepage "https://nzbget.com"
  url "https://github.com/nzbgetcom/nzbget/archive/refs/tags/v24.5.tar.gz"
  sha256 "d8a26fef9f92d63258251c69af01f39073a479e48c14114dc96d285470312c83"
  license "GPL-2.0-or-later"
  revision 1
  head "https://github.com/nzbgetcom/nzbget.git", branch: "develop"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "7a8e09e7e74541d8343bef47982475c2186d8e296e357bfb383448942161347d"
    sha256 cellar: :any,                 arm64_sonoma:  "c0556137ec4c0e326e83c43d9ab585e296970cfe31906220e1dc261cb39dd615"
    sha256 cellar: :any,                 arm64_ventura: "4eef24ab928fa122c43f2489d861244c57aadf584c402fc0453ca543b49ec1c3"
    sha256                               sonoma:        "b529bafe3e63cd40197b021d35168055ed438e83e4d3de611d3976081d581540"
    sha256                               ventura:       "b0801ac420cbd20d84fcfe4d7b26bf776d072ce7675d7f2fec09c9190dfc6270"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7ea1f0301b816abc15405ebedac03403c64cc8eeaf14572a6f4d43d3bd856d83"
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
