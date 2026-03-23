class Openrtsp < Formula
  desc "Command-line RTSP client"
  homepage "http://www.live555.com/openRTSP"
  url "https://download.live555.com/live.2026.03.23.tar.gz"
  mirror "https://download.videolan.org/pub/videolan/testing/contrib/live555/live.2026.03.23.tar.gz"
  mirror "https://pkg.freebsd.org/ports-distfiles/live.2026.03.23.tar.gz"
  # Keep a mirror as upstream tarballs are removed after each version
  sha256 "badb8ca20af208511eecd021fd2233da6646134c4333b8566dded37b0db40b8e"
  license "LGPL-3.0-or-later"

  livecheck do
    url "https://download.live555.com/"
    regex(/href=.*?live[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "fe1dff16782380d071efb3d90a716d8680258c3f4ae8e8dcaa6cf4ad72bd5cfa"
    sha256 cellar: :any,                 arm64_sequoia: "e585a6554fe1f57d655f3abe620379c8439d2e90173b71f10b50e2bbd214e4c1"
    sha256 cellar: :any,                 arm64_sonoma:  "a7829d4fe9427bfc67a52f4b1e670e8bd6daa3e86124bb2d1921c141ad816950"
    sha256 cellar: :any,                 sonoma:        "e53e37f3cd935311cde24577bf87fb27d32abdf01c3153971b96e81ac30e5f25"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7d01537636f167880525f6193c2251fde1f6d1c5e45032da68f2733b54e39148"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dbb56c622440ffdff0e8dbac70a5944249cf722c8de0d9ca61613884513c13fe"
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
