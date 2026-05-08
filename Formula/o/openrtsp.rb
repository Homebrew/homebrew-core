class Openrtsp < Formula
  desc "Command-line RTSP client"
  homepage "http://www.live555.com/openRTSP"
  url "https://download.live555.com/live.2026.04.22.tar.gz"
  mirror "https://download.videolan.org/pub/videolan/testing/contrib/live555/live.2026.04.22.tar.gz"
  mirror "https://pkg.freebsd.org/ports-distfiles/live.2026.04.22.tar.gz"
  # Keep a mirror as upstream tarballs are removed after each version
  sha256 "1ffd626ce2e2473196e55a473b7b5ba056326eeabf8fd5622cea6b123d8b6370"
  license "LGPL-3.0-or-later"

  livecheck do
    url "https://download.live555.com/"
    regex(/href=.*?live[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "d1a492c9899fa90970de7168285549ba75a5218f932d80d366eba23bbb209355"
    sha256 cellar: :any,                 arm64_sequoia: "31e947e6bdf414807ad4f028cfa7dba2da41a275e660d33e90dc364ab1765452"
    sha256 cellar: :any,                 arm64_sonoma:  "9a761e46e43bb23a4d420e848d33a9b8ed87ed33937307004bf311e2eb9e054e"
    sha256 cellar: :any,                 sonoma:        "c493f08b63f7346b42892bf5c06bcc783c16934ae1a16c3542b2ed51b73662d6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "051f61ebb0f8f9ef6873e044312f3ef01d3ad6db3ea88b8ef47dac2cca7faf44"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6ee691b638c038e6271ff6459cf1f44b8be70439aae0f72d48d8899270244cfe"
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
