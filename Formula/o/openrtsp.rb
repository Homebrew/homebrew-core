class Openrtsp < Formula
  desc "Command-line RTSP client"
  homepage "http://www.live555.com/openRTSP"
  url "https://download.live555.com/live.2026.11.27.tar.gz"
  mirror "https://download.videolan.org/pub/videolan/testing/contrib/live555/live.2026.11.27.tar.gz"
  mirror "https://pkg.freebsd.org/ports-distfiles/live.2026.11.27.tar.gz"
  # Keep a mirror as upstream tarballs are removed after each version
  sha256 "b10f5f5ae768c2fa9c175d7ad31b2e17dcbde9598ef368f012921f55ad69c336"
  license "LGPL-3.0-or-later"

  livecheck do
    url "https://download.live555.com/"
    regex(/href=.*?live[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    manifest_sha256 "2b9c1f4b23b73c5140b52bb032096aaff206744ab01038029d070370cd4e9839"
    sha256 cellar: :any, arm64_golden_gate: "750463352225383fff99830a671c0b8e945bbe47d3dcb5743a1b46e5eb77c09c"
    sha256 cellar: :any, arm64_tahoe:       "4325aecec9ab02a8ca5ae3f6e7ee2c3736b81fbef4803dcdc6f84dd0ddadb21c"
    sha256 cellar: :any, arm64_sequoia:     "d7035cbab6ef16a142fa53e4bf2a68e68a56e909bf7228c3723ed97cddee5a49"
    sha256 cellar: :any, arm64_linux:       "eb0b6c43730d2e62604654f2778b0850495055199e369c69be04189155335b68"
    sha256 cellar: :any, x86_64_linux:      "f6a85d483f27116becb7aa92899cd8e24d1aa267e4e9263b99ac619c34678b1f"
  end

  depends_on "openssl@4"

  deny_network_access!

  def install
    # "test" was added to std::atomic_flag in C++20
    # See https://github.com/rgaufman/live555/issues/45
    ENV.append "CXXFLAGS", "-std=c++20"

    # Avoid linkage to system OpenSSL
    libs = [
      dep("openssl").opt_lib/shared_library("libcrypto"),
      dep("openssl").opt_lib/shared_library("libssl"),
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
