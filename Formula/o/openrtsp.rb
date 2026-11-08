class Openrtsp < Formula
  desc "Command-line RTSP client"
  homepage "http://www.live555.com/openRTSP"
  url "https://download.live555.com/live.2026.11.08.tar.gz"
  mirror "https://download.videolan.org/pub/videolan/testing/contrib/live555/live.2026.11.08.tar.gz"
  mirror "https://pkg.freebsd.org/ports-distfiles/live.2026.11.08.tar.gz"
  # Keep a mirror as upstream tarballs are removed after each version
  sha256 "95eb2ad572a5f88d817717c00c534dbdfdeb2df0afaa0e0052a52c4f9f041a7c"
  license "LGPL-3.0-or-later"

  livecheck do
    url "https://download.live555.com/"
    regex(/href=.*?live[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "d1cb86b55c8b6232323774328ad18098bdaf9594203cfb09233897427a32d1c7"
    sha256 cellar: :any, arm64_tahoe:       "acad60ee5fe0c26edbaadcac332b619eaa0c2611205339f33d8777ffb8609b41"
    sha256 cellar: :any, arm64_sequoia:     "3beb51433a1b1610876913eeccee781194137e676fc06d272d9b556d83b9aae2"
    sha256 cellar: :any, arm64_linux:       "6543c13f6954113944e3c70aec5634ec187b023129e2a5fff238cd666aaec009"
    sha256 cellar: :any, x86_64_linux:      "9a22c6adb434f7f6664eb80696f7f445d685f6f39f4e12e4835dc87a3e968e81"
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
