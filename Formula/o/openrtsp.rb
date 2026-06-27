class Openrtsp < Formula
  desc "Command-line RTSP client"
  homepage "http://www.live555.com/openRTSP"
  url "https://download.live555.com/live.2026.06.24.tar.gz"
  mirror "https://download.videolan.org/pub/videolan/testing/contrib/live555/live.2026.06.24.tar.gz"
  mirror "https://pkg.freebsd.org/ports-distfiles/live.2026.06.24.tar.gz"
  # Keep a mirror as upstream tarballs are removed after each version
  sha256 "b22182db20fe554be886f74c453f6b900e471de9585a401b0b60228aebc27ef7"
  license "LGPL-3.0-or-later"

  livecheck do
    url "https://download.live555.com/"
    regex(/href=.*?live[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "d4adaa090532a10bb29ce8b65baa06b566573a25ec99a6c52eccf2d01f023db3"
    sha256 cellar: :any, arm64_sequoia: "a93fa82ef767827903f94c9e48851cdba65f25f2bd9b2d83c304759cfa405661"
    sha256 cellar: :any, arm64_sonoma:  "ab85b90305ae95a99ac77e698915b203386f12ece2589f3a3df4277b43472bb9"
    sha256 cellar: :any, sonoma:        "c96132fb0f995ee4721f905ab9dd2a304acc686125c90dcb4be26d2ded4b2d98"
    sha256 cellar: :any, arm64_linux:   "fb2767f05a879c00f45b812848483c78f71715cd71480ab65fab8c090969dd15"
    sha256 cellar: :any, x86_64_linux:  "8d906c69a2459222bf6abb469f803ff0bbde16613ce5a5ce96201f56b9736f79"
  end

  depends_on "openssl@3"

  def install
    # "test" was added to std::atomic_flag in C++20
    # See https://github.com/rgaufman/live555/issues/45
    ENV.append "CXXFLAGS", "-std=c++20"

    # Avoid linkage to system OpenSSL
    libs = [
      formula_opt_lib("openssl@3")/shared_library("libcrypto"),
      formula_opt_lib("openssl@3")/shared_library("libssl"),
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
