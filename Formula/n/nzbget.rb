class Nzbget < Formula
  desc "Binary newsgrabber for nzb files"
  homepage "https://nzbget.com"
  url "https://github.com/nzbgetcom/nzbget/archive/refs/tags/v26.2.tar.gz"
  sha256 "8642dda85b96e0af1acb927a0684cf84fa20c818aa989ebdc4569a254470319d"
  license "GPL-2.0-or-later"
  head "https://github.com/nzbgetcom/nzbget.git", branch: "develop"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "91f279cde43feaf58b004ab627add09d538441a7f089fa90e96347cdfd8bd752"
    sha256 cellar: :any, arm64_sequoia: "bb4792e37b963a2ccdb9c71da8b407f676ae31af79f7faf3f68a8d5257702d34"
    sha256 cellar: :any, arm64_sonoma:  "b14eccaa56ddc2467051339ed8d899fe57ce76984a258d9cd9602b8a42c8e3bb"
    sha256               sonoma:        "71ac192786a3e5035cfde58943fc5f88a30e23568bc5baf136b50b4aef64b93d"
    sha256 cellar: :any, arm64_linux:   "c232821c5ddca5e0be01ef1e0844dd00b27c64968f2496055a62c7e7655e4f6e"
    sha256 cellar: :any, x86_64_linux:  "86a2eba421b4ec886fc6ead5c49e8db4f2b0f6855107f272e03c3455957e0186"
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
