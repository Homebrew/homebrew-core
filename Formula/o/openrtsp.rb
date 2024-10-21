class Openrtsp < Formula
  desc "Command-line RTSP client"
  homepage "http://www.live555.com/openRTSP"
  url "http://www.live555.com/liveMedia/public/live.2024.10.11.tar.gz"
  mirror "https://download.videolan.org/pub/videolan/testing/contrib/live555/live.2024.10.11.tar.gz"
  # Keep a mirror as upstream tarballs are removed after each version
  sha256 "9c57a1eea2a888698efb4b068b84859ac23e7c14d75169ac9dce593799a4d290"
  license "LGPL-3.0-or-later"

  livecheck do
    url "http://www.live555.com/liveMedia/public/"
    regex(/href=.*?live[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "6dcdde9e8f1c73feb3dd24ba15c49bf673f8d2258570a21328e13269d4fa8688"
    sha256 cellar: :any,                 arm64_sonoma:  "273c9adca09df9837b750341344a6ffd9ac460ef13057bdb0d856ca88215a747"
    sha256 cellar: :any,                 arm64_ventura: "f931cfd7820381c572195c3e29235ad35f5c656abaf88b7baf56d5972db02347"
    sha256 cellar: :any,                 sonoma:        "6a0257a81d940960041b57a6b34fdfeae2d40aa1ee538f713bec4791c5ae9ea6"
    sha256 cellar: :any,                 ventura:       "0766e7a8ab39dbf265f06aa85c172037be83523cd7da471827e2e9d45823d3dc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "35f78e63a1b38779ae655c2ee6a115e74c575c35a87a302a206aacb0d95ceccf"
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
