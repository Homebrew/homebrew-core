class Nzbget < Formula
  desc "Binary newsgrabber for nzb files"
  homepage "https://nzbget.com"
  url "https://github.com/nzbgetcom/nzbget/archive/refs/tags/v24.8.tar.gz"
  sha256 "8d67af6c0aab025ca3da2f701ef62ce9c14a1cedc2e55600fd7e872ef60c0fdf"
  license "GPL-2.0-or-later"
  revision 1
  head "https://github.com/nzbgetcom/nzbget.git", branch: "develop"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "1ebc3d2536e834d12a8489391d56cd12cf512be113b05e349a996aa4b88ae06d"
    sha256 cellar: :any,                 arm64_sonoma:  "c2218d8de20843f46cea7bebf1f0a6773adb5d3f5c72042924cf75f0ae247cb1"
    sha256 cellar: :any,                 arm64_ventura: "7ffd4d5078071dc120e43dce0810980402f8faf866f256e02904137e5501bfb4"
    sha256                               sonoma:        "05a5bc4c4c9423fe95f07f7a108bb579dd910433652c5e03ee759ecf95536ba4"
    sha256                               ventura:       "665059b75e67d55104649f6a4a0e8a0367e4fc8893daa28a8988b14f79520e44"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cf2af090d596af4337247e13b14d5d7610369d3a2c1ad8cc78040e150d1a74b3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0a7fa53fca48285149fc0ba5eceb1d80a58b66b0ae24828d2a54f6c8b81ce45c"
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
