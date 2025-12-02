class Openrtsp < Formula
  desc "Command-line RTSP client"
  homepage "http://www.live555.com/openRTSP"
  url "http://www.live555.com/liveMedia/public/live.2025.11.06.tar.gz"
  mirror "https://download.videolan.org/pub/videolan/testing/contrib/live555/live.2025.11.06.tar.gz"
  # Keep a mirror as upstream tarballs are removed after each version
  sha256 "7614fa0a293e61b24bfd715a30a1c020fb4fe5490ebb02e71b0dadb5efc1d17c"
  license "LGPL-3.0-or-later"

  livecheck do
    url "http://www.live555.com/liveMedia/public/"
    regex(/href=.*?live[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "5baabb1fe27ee14414890176c8506a4ffc5bdb9ce0bc53141a40761f7eb4823c"
    sha256 cellar: :any,                 arm64_sequoia: "5c76a6d529589b9c121523e9ab0c16b33c303245699220c999b2a683f62b5298"
    sha256 cellar: :any,                 arm64_sonoma:  "90217a0b6197669b2772a6528f725bae71df56f6d9f46e2447e4a86450966036"
    sha256 cellar: :any,                 sonoma:        "929925dbc92aa1daa28bae947e8470090aa54c1b1a298c716241896efd0380bf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bbd233698491219e6a07cd8d55e544d3de1500d753c9a6ff2a80cc0616965c3b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f766e5ac689227ad005b6f80ebdf5d162ab080a2662648706ce8b2542954d6c4"
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
