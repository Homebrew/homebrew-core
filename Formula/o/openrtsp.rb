class Openrtsp < Formula
  desc "Command-line RTSP client"
  homepage "http://www.live555.com/openRTSP"
  url "https://download.live555.com/live.2026.09.21.tar.gz"
  mirror "https://download.videolan.org/pub/videolan/testing/contrib/live555/live.2026.09.21.tar.gz"
  mirror "https://pkg.freebsd.org/ports-distfiles/live.2026.09.21.tar.gz"
  # Keep a mirror as upstream tarballs are removed after each version
  sha256 "b719b39d7d8bf15d6ddc10a6df2c19999c1becd2cc0d8cb8b270d5755e666a57"
  license "LGPL-3.0-or-later"

  livecheck do
    url "https://download.live555.com/"
    regex(/href=.*?live[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "5119fd9429b10847e24753b6667baf35a5334837a92c858b932271a786ccb84d"
    sha256 cellar: :any, arm64_tahoe:       "1241b6337e0048910ac9ff84c18f554851155cb90f3e9460f338451a1cea864f"
    sha256 cellar: :any, arm64_sequoia:     "b8d2205e83cb8a4726f56a18f851edfd57315732398f2570b2ad13722d26b318"
    sha256 cellar: :any, arm64_linux:       "ef95a12f2c7e7aee65d4dc782d4c1add23f22abc49d226741b68c15b75815b48"
    sha256 cellar: :any, x86_64_linux:      "f8c7f699545e792d3364a90c1323b194bf798e0b693a6ab36bb1435ee4732b94"
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
