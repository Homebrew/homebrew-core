class Nzbget < Formula
  desc "Binary newsgrabber for nzb files"
  homepage "https://nzbget.com"
  url "https://github.com/nzbgetcom/nzbget/archive/refs/tags/v24.1.tar.gz"
  sha256 "9b823f5be183573cc51a7e4db5ac0529f5e3b98260676a7ce400784fdf230393"
  license "GPL-2.0-or-later"
  head "https://github.com/nzbgetcom/nzbget.git", branch: "develop"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "fadc9681b899c560e01f7fafaf6d5b2c4854e050860a481ddbbe791ba0347465"
    sha256 cellar: :any,                 arm64_ventura:  "75c249c6deb824525d37ee78723253a54f446848401318eb9d5a4f4ec272ed5b"
    sha256 cellar: :any,                 arm64_monterey: "1c7d5949aa3098db58df25a666658182a3d614a550a581ab236db8e95ce83b44"
    sha256                               sonoma:         "f3f71c1bc5b02e2ab10703e3eaefef1b94cd4bc36f549dac8ff9e4e22e79f82b"
    sha256                               ventura:        "c85097e3cace5713a78f7270220cca332b1e49df41016fa37678e507566b4064"
    sha256                               monterey:       "d8de0736cb19429e21aacbcab7a46ccdf9a74fe43dffc1a3d056cc6ead716881"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9f67e4fdc49065695c6eba3cd6e838072b6821a0484543c12c399b64ee421f61"
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
