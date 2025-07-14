class Nzbget < Formula
  desc "Binary newsgrabber for nzb files"
  homepage "https://nzbget.com"
  url "https://github.com/nzbgetcom/nzbget/archive/refs/tags/v25.2.tar.gz"
  sha256 "a557d6067e551ee77fd86a9f395a8407438edc3ee16ab6797830db25ba8e1662"
  license "GPL-2.0-or-later"
  head "https://github.com/nzbgetcom/nzbget.git", branch: "develop"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "0a550c2ba03578872a7f2983317ccebb4737ca158b12dd940e0a61e3c5832af1"
    sha256 cellar: :any,                 arm64_sonoma:  "420a3e2d979132839a9d2a4e8dd99f14e6a861951255b3e404d78eb2386cde63"
    sha256 cellar: :any,                 arm64_ventura: "ae7d6fcc21e52ce4fea1b3e1d0f61e90035f63fe4eb855053c1825807b3b484f"
    sha256                               sonoma:        "fe1c738c108bd62d7c48ec188b5c1e34c2eecf4c6973373d38b3fe12da211e71"
    sha256                               ventura:       "18c1d802062396691eb27f27a6ee560bcfa65d146c1126a78a2f6d4a116c3f53"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3d813e615f58fa4efaa208c7ed9818584f4149b88faaf71395c8b022045f8ebd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "78173ec478edec907afa5eae70cfc9419a32c15a564881210dfb7756bbe457c1"
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
