class Openrtsp < Formula
  desc "Command-line RTSP client"
  homepage "http://www.live555.com/openRTSP"
  url "https://download.live555.com/live.2026.11.04.tar.gz"
  mirror "https://download.videolan.org/pub/videolan/testing/contrib/live555/live.2026.11.04.tar.gz"
  mirror "https://pkg.freebsd.org/ports-distfiles/live.2026.11.04.tar.gz"
  # Keep a mirror as upstream tarballs are removed after each version
  sha256 "67c8b5f51edd04f7580f2a8a7778c125290955991c38d1d54afea49f4762a5e7"
  license "LGPL-3.0-or-later"

  livecheck do
    url "https://download.live555.com/"
    regex(/href=.*?live[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "bafd825801f63419a7d238a3dc91f6a74337a927954c1df4505daae436180b7c"
    sha256 cellar: :any, arm64_tahoe:       "c000244a0d142366fc1360b5a45c3ef78370679a96a7ad91d0b519fff7aac7b7"
    sha256 cellar: :any, arm64_sequoia:     "cb6c8ca48c25ece86c5c5c4ea5d7dae882551675eb30a39629b3397576cb9dcf"
    sha256 cellar: :any, arm64_linux:       "f24a30fda23c3c0c35e3f36039e5165c33a01853b091b5a5b683901167a021d9"
    sha256 cellar: :any, x86_64_linux:      "db9280f92b874ac5efd6e8a595cd6860f7e54c9a452aea6d1ac603a2c13ac0fa"
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
