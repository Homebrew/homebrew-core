class Openrtsp < Formula
  desc "Command-line RTSP client"
  homepage "http://www.live555.com/openRTSP"
  url "http://www.live555.com/liveMedia/public/live.2022.10.01.tar.gz"
  mirror "https://download.videolan.org/pub/videolan/testing/contrib/live555/live.2022.10.01.tar.gz"
  # Keep a mirror as upstream tarballs are removed after each version
  sha256 "429de73061e3fc6901c4d2f0b7562ae3f6233060ca4b5e182fe555d065cbdd45"
  license "LGPL-3.0-or-later"

  livecheck do
    url "http://www.live555.com/liveMedia/public/"
    regex(/href=.*?live[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "2f23bfb28041072267b6eac9f6a3f8521d8161433d740595106802fd2e38523d"
    sha256 cellar: :any,                 arm64_big_sur:  "5a87c21be839b97e370c6eac38d1f4fddefe7e961a87d037f3256e4c3e5ca338"
    sha256 cellar: :any,                 monterey:       "67063e9d9f7ef7ca62fa05b4fd21ccc04c418f61f9ec00431336d5e291e013a0"
    sha256 cellar: :any,                 big_sur:        "ea76ffb5939ea76773c704cb0e456d8308702aab34cf37bf3fc45854904971c8"
    sha256 cellar: :any,                 catalina:       "b16a2c4f725481f275d66692ee249e318891c27a7317742659f83fc6f0a91889"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "333e241c8d6aaef1fe8e9ac94305af36f6bf8905acd281a47d7f1eab79ac8cb9"
  end

  depends_on "openssl@1.1"

  def install
    # Avoid linkage to system OpenSSL
    libs = [
      Formula["openssl@1.1"].opt_lib/shared_library("libcrypto"),
      Formula["openssl@1.1"].opt_lib/shared_library("libssl"),
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
