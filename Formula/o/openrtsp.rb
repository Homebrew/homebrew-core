class Openrtsp < Formula
  desc "Command-line RTSP client"
  homepage "http://www.live555.com/openRTSP"
  url "http://www.live555.com/liveMedia/public/live.2024.02.15.tar.gz"
  mirror "https://download.videolan.org/pub/videolan/testing/contrib/live555/live.2024.02.15.tar.gz"
  # Keep a mirror as upstream tarballs are removed after each version
  sha256 "c87968c6a191c4ad517ba752143af8644361eff0127b095efd00adb2d599df9e"
  license "LGPL-3.0-or-later"

  livecheck do
    url "http://www.live555.com/liveMedia/public/"
    regex(/href=.*?live[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "c5b8aee028ece920f7f4e394e1268b5f3e9af56114e75fb32e5f82621e4c1930"
    sha256 cellar: :any,                 arm64_ventura:  "d86ea4f81ee083132960142d094dbb8aef829d5876ef9cb5fed84aef76e9ef18"
    sha256 cellar: :any,                 arm64_monterey: "86803a2e0cd2baa88d71b56d405c3f08fa56514b1eb15ad9628d0ddd6ab7fdd1"
    sha256 cellar: :any,                 sonoma:         "e9cb60cd9cd160b0ebade192a0972d9424a9c2761345697830bcb261b06ca5d8"
    sha256 cellar: :any,                 ventura:        "ff1688405bf904e10e2856588c8c1a91f8dab38d4eb0a0266534af1abc8c6981"
    sha256 cellar: :any,                 monterey:       "7344c4ce26b8983c729e333826810e7fa8cc5b2e54ae96d1fe68671a13e75d13"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1ba68cbaf7f70d6f7839c74e10895ac2c2aa3346c99b7f209005f3eacf475443"
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
