class Nzbget < Formula
  desc "Binary newsgrabber for nzb files"
  homepage "https://nzbget.com"
  url "https://github.com/nzbgetcom/nzbget/archive/refs/tags/v24.8.tar.gz"
  sha256 "8d67af6c0aab025ca3da2f701ef62ce9c14a1cedc2e55600fd7e872ef60c0fdf"
  license "GPL-2.0-or-later"
  revision 1
  head "https://github.com/nzbgetcom/nzbget.git", branch: "develop"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "2cf0b33adc4150258481607c90fd797f36c40a31cb63b285f620731b5daf627f"
    sha256 cellar: :any,                 arm64_sonoma:  "99354ebc3fde8a20e8c5bb04e5a5bd3cc943d4f25eb5d8e05fc327ce89c86dd5"
    sha256 cellar: :any,                 arm64_ventura: "0916cdd31a6cadc04cda1f35c29504c28a276b45ae212fd7790c3a1215a8d1b4"
    sha256                               sonoma:        "f13631c62c250c4d2e4ec6ca86366bb12c0b5cb816314af6aeccdbb8fa4abeb7"
    sha256                               ventura:       "7b31cf069283478797f2e5cc529b49345154e19988c7b5bafaf1f92ec65b0094"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b775bb24590c73da6e6a0135ef30c6567c851d7f507494af947d3be9120d5396"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2cf5881e65b97201b06574e9511572bff673971eca03c1d746955706f93d3f28"
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
