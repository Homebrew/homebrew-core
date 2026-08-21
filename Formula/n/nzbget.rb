class Nzbget < Formula
  desc "Binary newsgrabber for nzb files"
  homepage "https://nzbget.com"
  url "https://github.com/nzbgetcom/nzbget/archive/refs/tags/v26.2.tar.gz"
  sha256 "8642dda85b96e0af1acb927a0684cf84fa20c818aa989ebdc4569a254470319d"
  license "GPL-2.0-or-later"
  revision 1
  head "https://github.com/nzbgetcom/nzbget.git", branch: "develop"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "6a0bc2c593cafb79ee3e3bfafa114c8458c6778e09a89d64c166c65eb5fde404"
    sha256 cellar: :any, arm64_sequoia: "f26d24b20c481d59697b04efe2245ec873dad682e88acea0d9d526a3395eec8b"
    sha256 cellar: :any, arm64_sonoma:  "ce3bfae2e1e20e9a66932730a99f1ca84f43a5bce0193dd53895be9d5a35fb84"
    sha256               sonoma:        "fe985705c9813f7e08be390d86d2c169b2205d4233caa30eb5b004b7257195f5"
    sha256 cellar: :any, arm64_linux:   "78dc82a82ea506e6af8164b36cca9f25e96b1764a939a00e0ceb340681a00ba2"
    sha256 cellar: :any, x86_64_linux:  "5bb9327b5e30b9deccc827f730dd0e47d19f50746e48924aa03515276d4734a4"
  end

  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "openssl@3"
  depends_on "sevenzip"

  uses_from_macos "libxml2"
  uses_from_macos "ncurses"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    inreplace "nzbget.conf" do |s|
      if OS.mac?
        # Set upstream's recommended values for file systems without
        # sparse-file support (e.g., HFS+); see Homebrew/homebrew-core#972
        s.gsub! "DirectWrite=yes", "DirectWrite=no"
        s.gsub! "ArticleCache=0", "ArticleCache=700"
      end

      # Update 7z cmd to match homebrew binary
      s.gsub! "SevenZipCmd=7z", "SevenZipCmd=7zz"
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
