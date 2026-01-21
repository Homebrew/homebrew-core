class Nzbget < Formula
  desc "Binary newsgrabber for nzb files"
  homepage "https://nzbget.com"
  url "https://github.com/nzbgetcom/nzbget/archive/refs/tags/v25.4.tar.gz"
  sha256 "2603116ffaef4992621cf7a82ce300f41a676a312de784f2bac5058abc1a2385"
  license "GPL-2.0-or-later"
  revision 2
  head "https://github.com/nzbgetcom/nzbget.git", branch: "develop"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "d46e9483a24866f1151e2420c1f0c7ef1af0e172cac28cdf8f3ecdaef4b9f79f"
    sha256 cellar: :any,                 arm64_sequoia: "7f744a0302c49d41da4bd5e69cac30471e7233adb54b6013048c2cbd7cbbf7e3"
    sha256 cellar: :any,                 arm64_sonoma:  "d4442f6da16a0e188b5df2f8e726022f59c10aac5707c5ca88ff1a12b106d7b8"
    sha256                               sonoma:        "f043eef25e1295845c1ac8d7103c9b96865d5a66afac5d4696aec1184a22f4db"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4d067e667d5954731951e2de941643d2441387e6ed5389d8f6feaa6f69558ac3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f019219d401602546d6c537d888e73887ccd1fb55c220f0dc89401344de7163b"
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
