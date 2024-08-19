class Nzbget < Formula
  desc "Binary newsgrabber for nzb files"
  homepage "https://nzbget.com"
  url "https://github.com/nzbgetcom/nzbget/archive/refs/tags/v24.2.tar.gz"
  sha256 "4fbcfc4faa49be0dc9d0b85cfbae2e38043be1e2f6755e6891d48785baa9438b"
  license "GPL-2.0-or-later"
  revision 1
  head "https://github.com/nzbgetcom/nzbget.git", branch: "develop"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "e65c740f6d8452a78ef6e7b7c75ef219c72415dc9d199c5bd187c01c8bbbf33d"
    sha256 cellar: :any,                 arm64_ventura:  "135e32ca381d46996a7dcbaa235a1cd3045f6bd89857de01cd1ac059366acf57"
    sha256 cellar: :any,                 arm64_monterey: "1bdf12fd7460c1acf17d5bf57e49700b270b13ac8724206f2f71b08c4c58b855"
    sha256                               sonoma:         "b48d2d37fb08de9e4c023f6fff9065b6bd7b6db9f8ba31031b27212178ce4b29"
    sha256                               ventura:        "a4fbbe58120c77e1ce583774fdcf18b85b56a3e99375dee3492e96835c4d9e91"
    sha256                               monterey:       "7ee6109325d674327ddb8328ec9dd4ea77561e496fd6899f5dc2a1d22945a916"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c161baa92be6db5c451e73a4282acdafcfd10f6a0528ea0eab8eca6dd4552432"
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
