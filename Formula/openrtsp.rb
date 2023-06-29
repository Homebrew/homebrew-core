class Openrtsp < Formula
  desc "Command-line RTSP client"
  homepage "http://www.live555.com/openRTSP"
  url "http://www.live555.com/liveMedia/public/live.2023.06.14.tar.gz"
  mirror "https://download.videolan.org/pub/videolan/testing/contrib/live555/live.2023.06.14.tar.gz"
  # Keep a mirror as upstream tarballs are removed after each version
  sha256 "3da5d2270cfc2f07b381759581af60d92e642be60f491567ae1687ff9513d261"
  license "LGPL-3.0-or-later"

  livecheck do
    url "http://www.live555.com/liveMedia/public/"
    regex(/href=.*?live[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "b5a661a89f11061cd3b887fa351212f5bfaa623133e85420834e4856bb50a864"
    sha256 cellar: :any,                 arm64_monterey: "8c0e705a475b25bf2c1c6333f903bc2869bfda03ee7f9d5b660c138b20cf9c17"
    sha256 cellar: :any,                 arm64_big_sur:  "4432b8ca614758aaf2b1b6d7dad1da6b8cfada9fd2c71ea3d7f3da3df45586e3"
    sha256 cellar: :any,                 ventura:        "1a14443c123b7526655c9d831c119b375d8e277e3d390e64e1cfb472631f3186"
    sha256 cellar: :any,                 monterey:       "9b56d8d4af62f85344b2834fdab21d698c725413df916071dd8d76d0e4ae80ea"
    sha256 cellar: :any,                 big_sur:        "97e90b0438f310018295712e1e9b189dd877b061c12e8bd6a1c48e57f3f208f6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5554f3ed7255f9487391ec3a4fd1c1428b5c726d2643b852c48c89ed33aa2299"
  end

  depends_on "openssl@3"

  def install
    ENV.cxx11

    # Avoid linkage to system OpenSSL
    libs = [
      Formula["openssl@3"].opt_lib/shared_library("libcrypto"),
      Formula["openssl@3"].opt_lib/shared_library("libssl"),
    ]

    os_flag = OS.mac? ? "macosx-no-openssl" : "linux-no-openssl"
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
