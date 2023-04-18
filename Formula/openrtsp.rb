class Openrtsp < Formula
  desc "Command-line RTSP client"
  homepage "http://www.live555.com/openRTSP"
  url "http://www.live555.com/liveMedia/public/live.2023.03.30.tar.gz"
  mirror "https://download.videolan.org/pub/videolan/testing/contrib/live555/live.2023.03.30.tar.gz"
  # Keep a mirror as upstream tarballs are removed after each version
  sha256 "bffd4d87c76271d59e371169edb6a484468a078cac2ad4459f22caa8d989dad4"
  license "LGPL-3.0-or-later"

  livecheck do
    url "http://www.live555.com/liveMedia/public/"
    regex(/href=.*?live[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "ac40fd2fb2725f77dd982ad16ffbb9dc81900c0ca5047a9c600fe9c7756de1b1"
    sha256 cellar: :any,                 arm64_monterey: "d6f2fc31ca245bc61101ab6c0a3b3e9f29a0dbe4daa3519d2873049f1b78f1bd"
    sha256 cellar: :any,                 arm64_big_sur:  "495cf05250e7f79389fb9c311a886e2165a42ce16146d13345605b29b10dafda"
    sha256 cellar: :any,                 ventura:        "773997459841fe1be81d845ef0b4151e4c12b78173eb3adfcd96ba12e0fdcb8b"
    sha256 cellar: :any,                 monterey:       "bd72601d6be51f0cd85e84f0bf2dfdee3fdac4f44746790c934896ac07225b0c"
    sha256 cellar: :any,                 big_sur:        "07af98e65dd3b3b58299d1ba26f56cf7b368bc8b1595b9f942a0c124872ebfbe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d59b49edc999504ae1f35ac3b566e855920aaeb5408dd297e9d2bae8eb75c58b"
  end

  depends_on "openssl@3"

  # Fix usage of IN6ADDR_ANY_INIT macro (error: expected expression). See:
  # https://pubs.opengroup.org/onlinepubs/9699919799/basedefs/netinet_in.h.html
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/2eabc6f/openrtsp/openrtsp.2022.11.19.patch"
    sha256 "33f6b852b2673e59cce7dedb1e6d5461a23d352221236c5964de077d137120cd"
  end

  def install
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
