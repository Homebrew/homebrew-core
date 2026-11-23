class Openrtsp < Formula
  desc "Command-line RTSP client"
  homepage "http://www.live555.com/openRTSP"
  url "https://download.live555.com/live.2026.11.22.tar.gz"
  mirror "https://download.videolan.org/pub/videolan/testing/contrib/live555/live.2026.11.22.tar.gz"
  mirror "https://pkg.freebsd.org/ports-distfiles/live.2026.11.22.tar.gz"
  # Keep a mirror as upstream tarballs are removed after each version
  sha256 "f2cdb4101c4be01d6b61c2ac8cd1674c711eb00c4bbb43a492e52ae5761244d6"
  license "LGPL-3.0-or-later"

  livecheck do
    url "https://download.live555.com/"
    regex(/href=.*?live[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    manifest_sha256 "598efbd2b1961ffc8e97523c35559aff2c48a50e92a1e13836706f4411458cbd"
    sha256 cellar: :any, arm64_golden_gate: "3898f1811943c9318b836dedb068ff9524487dd51a2404001d0a94eccd29aa65"
    sha256 cellar: :any, arm64_tahoe:       "a9b929e4dd12d4842090c5ce0dfae1633b781a1ae0724bf1f6be566007e18bb1"
    sha256 cellar: :any, arm64_sequoia:     "656978932a69cc7ae052af2789e8cd5e0fa7f0438df35992e593b48a41dcc3c7"
    sha256 cellar: :any, arm64_linux:       "ee3525314a4e494d8889a335bb5a43336421914e498b4ad4ba15e62bc9f59de0"
    sha256 cellar: :any, x86_64_linux:      "3d986f237935264b037147114f8393ebe46f10767ac92bc05fae2735c3160474"
  end

  depends_on "openssl@4"

  deny_network_access!

  def install
    # "test" was added to std::atomic_flag in C++20
    # See https://github.com/rgaufman/live555/issues/45
    ENV.append "CXXFLAGS", "-std=c++20"

    # Avoid linkage to system OpenSSL
    libs = [
      formula_opt_lib("openssl@4")/shared_library("libcrypto"),
      formula_opt_lib("openssl@4")/shared_library("libssl"),
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
