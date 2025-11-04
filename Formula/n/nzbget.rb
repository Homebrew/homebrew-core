class Nzbget < Formula
  desc "Binary newsgrabber for nzb files"
  homepage "https://nzbget.com"
  url "https://github.com/nzbgetcom/nzbget/archive/refs/tags/v25.4.tar.gz"
  sha256 "2603116ffaef4992621cf7a82ce300f41a676a312de784f2bac5058abc1a2385"
  license "GPL-2.0-or-later"
  revision 1
  head "https://github.com/nzbgetcom/nzbget.git", branch: "develop"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "e0944049a0fd6986fee0d4ff59a1f43eb7eb512d878c962021bf8396b62f17b2"
    sha256 cellar: :any,                 arm64_sequoia: "6fc575c3c1c5ad4fc169754e791e1f6d175039ef3ac74892cb1d82fd0db6c6d3"
    sha256 cellar: :any,                 arm64_sonoma:  "8f797037cc0fa4329116f53979e2d285122dd20c2b06951613fcf929c3c19b6d"
    sha256                               sonoma:        "2dbae06c6fa37c6a8a0915878abc24257903b4975714f816b3c5cde9fa81fba9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "56477e369681e9d60a655ee8b80ecaab81203151e28bacee842478d56addf9c8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f48ea7ad186fa87a9a81d79fe460c90f879cd96c1cc83e6b6069e6811c36f257"
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
