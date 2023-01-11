class Openrtsp < Formula
  desc "Command-line RTSP client"
  homepage "http://www.live555.com/openRTSP"
  url "http://www.live555.com/liveMedia/public/live.2023.01.11.tar.gz"
  mirror "https://download.videolan.org/pub/videolan/testing/contrib/live555/live.2023.01.11.tar.gz"
  # Keep a mirror as upstream tarballs are removed after each version
  sha256 "4d6efdb693a6cb337c28a9ac042256b9c4f355fcffe8d676e63ec05d885d821e"
  license "LGPL-3.0-or-later"

  livecheck do
    url "http://www.live555.com/liveMedia/public/"
    regex(/href=.*?live[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "cffe3dfb880e28387e1db79fdcfeeb6ab75473e97f59af3363f5a15eed2ff4fe"
    sha256 cellar: :any,                 arm64_monterey: "1229843396cba7d7ef7d2507e0e6715ab2bd376dc827a102f3d8fee525c46e8a"
    sha256 cellar: :any,                 arm64_big_sur:  "45bdba794965ad07fb8f8df2421334430c761229549dfb3282bbb1a69d5a7c60"
    sha256 cellar: :any,                 ventura:        "13dbcf5a4b608213e29979969fb65bc193d91e38b958bd99cd72e76e4b1e17ea"
    sha256 cellar: :any,                 monterey:       "c9e35ac2240aacac9abdb20e67e49f604b9534f683e1c86e8051e7b7076f2106"
    sha256 cellar: :any,                 big_sur:        "1b0a9f1ff3ba8a520b1f32d91c8f06252ae862bc47513e1ba5b3845491944b2f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "52e13f68f34951ee2a9cb770193294e6a04537d08732db7a05599846216acea6"
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
