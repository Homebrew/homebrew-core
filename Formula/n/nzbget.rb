class Nzbget < Formula
  desc "Binary newsgrabber for nzb files"
  homepage "https://nzbget.com"
  url "https://github.com/nzbgetcom/nzbget/archive/refs/tags/v24.0.tar.gz"
  sha256 "f8b66551b943f72442a0fb00d8872a0e9c92c829e63d6a74c35888b7cb658dca"
  license "GPL-2.0-or-later"
  head "https://github.com/nzbgetcom/nzbget.git", branch: "develop"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "424609183d3f7448f1c93007757055e2b6b24959a7d3ad6c32e5bcfd0dce2f85"
    sha256 cellar: :any,                 arm64_ventura:  "b79807e390d6cbcafce9062410448787ea9ccc2ef28844f3f68ae272416955f6"
    sha256 cellar: :any,                 arm64_monterey: "e56130134626a68d6ac0a7017f89e633dab04a50bd8f709a9334c4907041187b"
    sha256                               sonoma:         "816d9237ebdfb8204a7fee061e567b2650913f8f5ffc60fe4de2fe8d7323920b"
    sha256                               ventura:        "ccc543b7ec79b1dd4746ce076a65685fa4f583badfcff792b5cb5befd9e42def"
    sha256                               monterey:       "5a086ed7d578afc075a62e2ea5d84542f4cc94bea2686052b5649d613635264b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bda01a44e9c866bd074cafc71f2ea1afaaf960922f669653006351dc79b88617"
  end

  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "openssl@3"
  depends_on "sevenzip"

  uses_from_macos "libxml2"
  uses_from_macos "ncurses"

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"

    # nzbget CMake build does not strip binary
    # must be removed in v25, tracking issue https://github.com/nzbgetcom/nzbget/issues/257
    system "strip", "build/nzbget"

    system "cmake", "--install", "build"

    # remove default nzbget.conf to prevent linking
    # must be removed in v25, tracking issue https://github.com/nzbgetcom/nzbget/issues/257
    rm prefix/"etc/nzbget.conf"

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
    system "#{bin}/nzbget", "-D", "-c", etc/"nzbget.conf"
    # Query server for version information
    system "#{bin}/nzbget", "-V", "-c", etc/"nzbget.conf"
    # Shutdown server daemon
    system "#{bin}/nzbget", "-Q", "-c", etc/"nzbget.conf"
  end
end
