class Nzbget < Formula
  desc "Binary newsgrabber for nzb files"
  homepage "https://nzbget.com"
  url "https://github.com/nzbgetcom/nzbget/archive/refs/tags/v26.0.tar.gz"
  sha256 "9b683ce96d7a2e5e702a169e3fbfd16824cfe0ce8ed887c76cc25a574f69c9cd"
  license "GPL-2.0-or-later"
  head "https://github.com/nzbgetcom/nzbget.git", branch: "develop"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "0ef5b4f7469e5631621c1ed63d84933f7352abc73b937864bef5daecf00fa087"
    sha256 cellar: :any,                 arm64_sequoia: "64f66197a63d763cb07c3cdf1d7fc7b6700133ebb028aed7333838cee038b9ad"
    sha256 cellar: :any,                 arm64_sonoma:  "c57ca253d74301155b648a4998f5ed5c24f878995ceaaf5142aefd1429ec18c5"
    sha256                               sonoma:        "cfc0132db636459975d13d7670b11bc3be865932135ab4e4d079c1bfb9f55fea"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c5d6e7929ac4cafac423cee1b6429a3d2728b9973d512af8ef478437d4402c48"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5baf160d0c98f2e683488824e3ee822a58b6f5abaab36f6f820036d53931965a"
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
