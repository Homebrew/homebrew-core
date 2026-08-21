class Openrtsp < Formula
  desc "Command-line RTSP client"
  homepage "http://www.live555.com/openRTSP"
  url "https://download.live555.com/live.2026.08.14.tar.gz"
  mirror "https://download.videolan.org/pub/videolan/testing/contrib/live555/live.2026.08.14.tar.gz"
  mirror "https://pkg.freebsd.org/ports-distfiles/live.2026.08.14.tar.gz"
  # Keep a mirror as upstream tarballs are removed after each version
  sha256 "85848fb28df98a77a6e745959cc3ecf5f541f34c8ffef9021b9f1c2e682edee0"
  license "LGPL-3.0-or-later"

  livecheck do
    url "https://download.live555.com/"
    regex(/href=.*?live[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "2e62273aea63d77bf275e55ed7b71f302b93e7043ab2ff345157305e2f09a24f"
    sha256 cellar: :any, arm64_sequoia: "d878a82cfa25859bd2651e61c54fe275552dd2d991293f6fd30c4cb7a4c6a24e"
    sha256 cellar: :any, arm64_sonoma:  "d35cf5267cda37c252fba75a57d7f68e68ff8c8d34a401f587b32cbd49d05245"
    sha256 cellar: :any, sonoma:        "0f569bfc1a76733ac80eca4316a82603258c87fc993f3005ccc97e86baa8cb55"
    sha256 cellar: :any, arm64_linux:   "dc82120f37814eb613d209f1ce56fd9e1d57a4c8de15636f7a26707b1dc5a8cc"
    sha256 cellar: :any, x86_64_linux:  "21c1af2bc6f4752385142c47a246902f2ede1d24f808b06ab761ae1dc9c097c0"
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
