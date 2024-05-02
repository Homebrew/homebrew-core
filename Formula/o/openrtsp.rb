class Openrtsp < Formula
  desc "Command-line RTSP client"
  homepage "http://www.live555.com/openRTSP"
  url "http://www.live555.com/liveMedia/public/live.2024.04.19.tar.gz"
  mirror "https://download.videolan.org/pub/videolan/testing/contrib/live555/live.2024.04.19.tar.gz"
  # Keep a mirror as upstream tarballs are removed after each version
  sha256 "e6c2ebfec6772c1f37084271e4e5236abc7f0e1fc4489f9869763440200ddcc2"
  license "LGPL-3.0-or-later"

  livecheck do
    url "http://www.live555.com/liveMedia/public/"
    regex(/href=.*?live[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "84531693364ab08e0f9b9defe126cdcbe0402968f806fd15faed40cac128a7b3"
    sha256 cellar: :any,                 arm64_ventura:  "915830c96afb93e651a6e03abe3d2ef2eb25e8b3e459acd5733ec18a372ec5e4"
    sha256 cellar: :any,                 arm64_monterey: "a93cf4a9dffd581eceb49fe4f631154540b8455bd6ab1b1f7155801574df952c"
    sha256 cellar: :any,                 sonoma:         "59f01363b02a5202dcf6a804b112c617f8a1b73e78c2aa4f148ab7294e61994e"
    sha256 cellar: :any,                 ventura:        "c04d769310d8156a12d55be0d61a6efb2b62dd4b5d1edde3d11f60484a8d179d"
    sha256 cellar: :any,                 monterey:       "d54a1a47a8d2d570c358e8a7487f0f4c2c84cffeeff14cafeb304bd1a3c6d224"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ba4ecc970920a21c96fc741966fcc2380bb0c9719fff9c30313d26aae387fa9a"
  end

  depends_on "openssl@3"

  # Support CXXFLAGS when building on macOS
  # PR ref: https://github.com/rgaufman/live555/pull/46
  # TODO: Remove once changes land in a release
  patch do
    url "https://github.com/rgaufman/live555/commit/16701af5486bb3a2d25a28edaab07789c8a9ce57.patch?full_index=1"
    sha256 "2d98a782081028fe3b7daf6b2db19e99c46f0cadab2421745de907146a3595cb"
  end

  def install
    # "test" was added to std::atomic_flag in C++20
    # See https://github.com/rgaufman/live555/issues/45
    ENV.append "CXXFLAGS", "-std=c++20"

    # Avoid linkage to system OpenSSL
    libs = [
      Formula["openssl@3"].opt_lib/shared_library("libcrypto"),
      Formula["openssl@3"].opt_lib/shared_library("libssl"),
    ]

    os_flag = OS.mac? ? "macosx-bigsur" : "linux"
    system "./genMakefiles", os_flag
    system "make", "PREFIX=#{prefix}",
           "LIBS_FOR_CONSOLE_APPLICATION=#{libs.join(" ")}", "install"

    # Move the testing executables out of the main PATH
    libexec.install Dir.glob(bin/"test*")
  end

  def caveats
    <<~EOS
      Testing executables have been placed in:
        #{libexec}
    EOS
  end

  test do
    assert_match "GNU", shell_output("#{bin}/live555ProxyServer 2>&1", 1)
  end
end
