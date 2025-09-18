class Nzbget < Formula
  desc "Binary newsgrabber for nzb files"
  homepage "https://nzbget.com"
  url "https://github.com/nzbgetcom/nzbget/archive/refs/tags/v25.3.tar.gz"
  sha256 "dc875b96606d0bc1dc6514fd51950f8bd6075698d6e29742ce145d2ae2553501"
  license "GPL-2.0-or-later"
  head "https://github.com/nzbgetcom/nzbget.git", branch: "develop"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "bc750b166f6f51a0d64f84a0b08400cf4e6f7251e429dee17ab559254c7ff15e"
    sha256 cellar: :any,                 arm64_sequoia: "8d387a7d880402135a9b13bebf091594bbb56a25856a420d729fb9aeae826d28"
    sha256 cellar: :any,                 arm64_sonoma:  "5de1bac6efe1d3fa1b22a35890b67dbded144acbb30629baba72f5e430de61a4"
    sha256 cellar: :any,                 arm64_ventura: "ae1cc06180e289a4aa35165d251526dc43cab504e7e4bafc9822dcc2e7d3edc6"
    sha256                               sonoma:        "bacc7a61b3f25871aab0e79db70976eef853d0e9210fd4b3744fe85ff2366d00"
    sha256                               ventura:       "edfe1b149687758951bd4b55d6873ec2b5cb69c973169f23efbe0b1f0617fd79"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "31ad4766584fe5cf5742575af01fb556507146da17aad1983725026e4a5c71d2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b42ada4a987b60271c4fc5888a205d7ace0d78df7bcd8b4298ce300ebfbaf205"
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
