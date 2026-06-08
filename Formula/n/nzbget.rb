class Nzbget < Formula
  desc "Binary newsgrabber for nzb files"
  homepage "https://nzbget.com"
  url "https://github.com/nzbgetcom/nzbget/archive/refs/tags/v26.1.tar.gz"
  sha256 "7ed0940f18635986f096d666e5e0b737ef8ae362e4a538b46a507bacb61b09ed"
  license "GPL-2.0-or-later"
  head "https://github.com/nzbgetcom/nzbget.git", branch: "develop"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "f55c4fc0ae84b75887ac649fefbc3ef0fd910a3c60d1428e0901e0d3e47542a5"
    sha256 cellar: :any,                 arm64_sequoia: "4e8cfb089112e0cbf712090eb6346a47c180b513682a39633466265bd41d6a64"
    sha256 cellar: :any,                 arm64_sonoma:  "e022f6fb8a2b280050137a6f7d49e449671a9b0fa1dd33eb1bce9d504b10c083"
    sha256                               sonoma:        "d715117f346123e181d078e78e0441ccf239f23da3a46b38f7d12ad812de72db"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ced80fbc1a1dbf7e63cbeb98eaa036f39a239b542c35ab47136e69e8e2623865"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "777066fbced98655c14a0c63194d5dd386a0d4acca3be4b8e2c5bc8a5ec997b3"
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
