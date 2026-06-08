class Openrtsp < Formula
  desc "Command-line RTSP client"
  homepage "http://www.live555.com/openRTSP"
  url "https://download.live555.com/live.2026.06.01.tar.gz"
  mirror "https://download.videolan.org/pub/videolan/testing/contrib/live555/live.2026.06.01.tar.gz"
  mirror "https://pkg.freebsd.org/ports-distfiles/live.2026.06.01.tar.gz"
  # Keep a mirror as upstream tarballs are removed after each version
  sha256 "d95338592c28a15dce572285f0bdc7f4fe009baa2652af1a5296f22560206d2a"
  license "LGPL-3.0-or-later"

  livecheck do
    url "https://download.live555.com/"
    regex(/href=.*?live[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "bae363e1561bc157b5cb8c1e37134a06e5dcd02edb52d8f7e7a0e574a3992e31"
    sha256 cellar: :any, arm64_sequoia: "8e0bb2635bd0b129b9daf66063d2bd7ba00e7fe7a651e686fd15721e66d4ff88"
    sha256 cellar: :any, arm64_sonoma:  "2fe16bfe6e1bc0de58633d764080676c6ce0c49701c175ea9658e307fd927ec7"
    sha256 cellar: :any, sonoma:        "532a249687e51291f347ff24970d1e739ea968d2b5577b5746efd7689b1deaba"
    sha256 cellar: :any, arm64_linux:   "1348874d209e3c3a34e60dd5b2662f2be69b2378636189ccc06cc17fac52ce5a"
    sha256 cellar: :any, x86_64_linux:  "35d77882b6591aa6b7ece84eb308afe78ef88351273fde3007b399ec85af98fe"
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
