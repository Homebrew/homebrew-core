class Openrtsp < Formula
  desc "Command-line RTSP client"
  homepage "http://www.live555.com/openRTSP"
  url "http://www.live555.com/liveMedia/public/live.2024.03.08.tar.gz"
  mirror "https://download.videolan.org/pub/videolan/testing/contrib/live555/live.2024.03.08.tar.gz"
  # Keep a mirror as upstream tarballs are removed after each version
  sha256 "c16502e046f1c5f2be3b15e2c8d6cd30639b54c64ea9bfbc8d31b4efca670de5"
  license "LGPL-3.0-or-later"

  livecheck do
    url "http://www.live555.com/liveMedia/public/"
    regex(/href=.*?live[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "3b42a9d50939a8b4fd0a13faf1a62e8c298d4aa1f11704148dc10c18829c9001"
    sha256 cellar: :any,                 arm64_ventura:  "81465a695adca915a25d66cd9bff3d6d0d83123fab2957e3a3d2dc1656c77edd"
    sha256 cellar: :any,                 arm64_monterey: "782e8863e9c5b32876b5ca73fbdf9bb7b46364a39516fe631607081475d52802"
    sha256 cellar: :any,                 sonoma:         "6ad3cbcc8cbfbc90c383be092082e6136979082ea3057e162a68b03436e20af8"
    sha256 cellar: :any,                 ventura:        "986353f538f7e7ae4f0c7d1a6efa6fb2941e8dd03ca09daf474f33356941de06"
    sha256 cellar: :any,                 monterey:       "547489f3f59627d49b0a44f9f25038f5086c672d98dfdaaddb292e034795bb39"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2c62b0c10c7daec6a973eccc002ac349df875de2c841e61cee1bdcc7c990751a"
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
