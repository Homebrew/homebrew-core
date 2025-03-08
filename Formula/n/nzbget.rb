class Nzbget < Formula
  desc "Binary newsgrabber for nzb files"
  homepage "https://nzbget.com"
  url "https://github.com/nzbgetcom/nzbget/archive/refs/tags/v24.7.tar.gz"
  sha256 "41bdb7dc737ad8cacd3a19506b7363db12843e2957dd64d49bbd034c6da3fe4b"
  license "GPL-2.0-or-later"
  head "https://github.com/nzbgetcom/nzbget.git", branch: "develop"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "be8f922f31a0cacc1a54f1ef2594e24c9b2f9a7460ec95b7a2461218dbdd0792"
    sha256 cellar: :any,                 arm64_sonoma:  "737447e5a37ee0e3820536baf6cdb8799dbb22ad3d95c86ef12ff90b28663b02"
    sha256 cellar: :any,                 arm64_ventura: "3d581dcc844a7d1d61664a50f1a56a5b7e4c175ba53af2e7dbfdabe7d6fcaefd"
    sha256                               sonoma:        "a8e093cf539afd2bc09924a33e08ad21cede2b325959cde722c4b5eed7f177ea"
    sha256                               ventura:       "b4d18f45a2ab5bbd1b46317a96fe1a63bcf1e430c8930697e325c29515617052"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e70d90bbd8fae9c246a103a83008dd21df6f5d101089f710a37992ae633c6340"
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
