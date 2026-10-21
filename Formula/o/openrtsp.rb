class Openrtsp < Formula
  desc "Command-line RTSP client"
  homepage "http://www.live555.com/openRTSP"
  url "https://download.live555.com/live.2026.10.17.tar.gz"
  mirror "https://download.videolan.org/pub/videolan/testing/contrib/live555/live.2026.10.17.tar.gz"
  mirror "https://pkg.freebsd.org/ports-distfiles/live.2026.10.17.tar.gz"
  # Keep a mirror as upstream tarballs are removed after each version
  sha256 "577b2fe2c5fe2c0240707e8be2d3e3fdb0c7eea0d7aca8ec84d75974773b5cd5"
  license "LGPL-3.0-or-later"

  livecheck do
    url "https://download.live555.com/"
    regex(/href=.*?live[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "7dd9ab5d84ec5003e56e35e1e17c87ce6d3de5961aaec7f7c7409fa97a8ea719"
    sha256 cellar: :any, arm64_tahoe:       "9139fc3351899af5fc24c57790920862335a993c7d02db41bd423c553d12f284"
    sha256 cellar: :any, arm64_sequoia:     "1e1e9555cb529b8578003e39c2c8b1354a6d23e95d7dc76a7846b27f0cb4d81b"
    sha256 cellar: :any, arm64_linux:       "5983f8d6be6400b5579e65a5554c86e3fa802248d0cc3371c8e2ed28102ed86f"
    sha256 cellar: :any, x86_64_linux:      "610634ae634ca112fc59a5ad8aa9115b58b5553842bd0d0e95430582d4a27d7f"
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
