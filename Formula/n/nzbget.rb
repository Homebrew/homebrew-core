class Nzbget < Formula
  desc "Binary newsgrabber for nzb files"
  homepage "https://nzbget.com"
  url "https://github.com/nzbgetcom/nzbget/archive/refs/tags/v26.3.tar.gz"
  sha256 "3a6a2a7c8bf5e7156dacb563e76d65df4aa53390e24040115c4406771ec3a19b"
  license "GPL-2.0-or-later"
  head "https://github.com/nzbgetcom/nzbget.git", branch: "develop"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "31b75d474ef6ff7cb1357bc70976260d89633247fb34976700d57e291f672b0e"
    sha256 cellar: :any, arm64_tahoe:       "6fc002036c997b87969be114ff9d4907b51d3724f49da1b4330300f2279bc0b4"
    sha256 cellar: :any, arm64_sequoia:     "41b13ca08f2e65a80d0438772b44a60c0f324af04c6d3ba1e186606f97a028ac"
    sha256 cellar: :any, arm64_sonoma:      "e315d728749006e01b59eba7496f985a87b9e6bdd810880cb9353ace32fa8c33"
    sha256               sonoma:            "d8c21a11f9028f519801a9faba068902662f9494a8e7b926914b0e6f94caf437"
    sha256 cellar: :any, arm64_linux:       "f80497814b8e97d8c5488ffa4d91152f12d58ed0b44a6aa617670b205c585157"
    sha256 cellar: :any, x86_64_linux:      "fdde4ce747047610e991505459bbc268878af68e38e01846705d8dda367faf6a"
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
