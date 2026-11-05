class Openrtsp < Formula
  desc "Command-line RTSP client"
  homepage "http://www.live555.com/openRTSP"
  url "https://download.live555.com/live.2026.11.05.tar.gz"
  mirror "https://download.videolan.org/pub/videolan/testing/contrib/live555/live.2026.11.05.tar.gz"
  mirror "https://pkg.freebsd.org/ports-distfiles/live.2026.11.05.tar.gz"
  # Keep a mirror as upstream tarballs are removed after each version
  sha256 "a9001fed451a2e5bc429f1f4cb4efd3eb9840ca429891f7e64f743a5a44b7333"
  license "LGPL-3.0-or-later"

  livecheck do
    url "https://download.live555.com/"
    regex(/href=.*?live[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "60d858e6e9927dd91cc756d894ef905b9dfb5be28a7e778093096c3f50e0fb5d"
    sha256 cellar: :any, arm64_tahoe:       "02c7aab39aebe9a90eb734dac388d3ee097681d5089792224884a39e71ac86aa"
    sha256 cellar: :any, arm64_sequoia:     "3659ed4007bb6824a868ee97eeabd54c3b2199de94078fb01d71a4f240206f27"
    sha256 cellar: :any, arm64_linux:       "a122101b250ac154507e358c3b1a43b70f60d90461b7166a7615f412bdc5744a"
    sha256 cellar: :any, x86_64_linux:      "df49d38a4c1b47c44470da574aa021980b86592b4e1c864b0ab0ead3015f13fb"
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
