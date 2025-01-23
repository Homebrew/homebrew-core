class Openrtsp < Formula
  desc "Command-line RTSP client"
  homepage "http://www.live555.com/openRTSP"
  url "http://www.live555.com/liveMedia/public/live.2025.01.17.tar.gz"
  mirror "https://download.videolan.org/pub/videolan/testing/contrib/live555/live.2025.01.17.tar.gz"
  # Keep a mirror as upstream tarballs are removed after each version
  sha256 "273d9cf77468015c2377e50e384e3eea67cf255c75fe60a175e9e0917afe847b"
  license "LGPL-3.0-or-later"

  livecheck do
    url "http://www.live555.com/liveMedia/public/"
    regex(/href=.*?live[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "be6c756cce25700799f95e2636eb587cd546b4f88ff0e787e2633127bdfeaa32"
    sha256 cellar: :any,                 arm64_sonoma:  "0f205dc3339d3f34dd2487b258b7c68a97fa8a3c41b4511368caa0c3dfb88ff2"
    sha256 cellar: :any,                 arm64_ventura: "30b4ad53256eb145f7b1da8b8fdd58d519c1ec8fec542be4c1ab2a7219f143ac"
    sha256 cellar: :any,                 sonoma:        "153560f4f26f7984f96a829b1b81c7ebddb3625088c5d3eb7bf96975f38e9924"
    sha256 cellar: :any,                 ventura:       "b86809df4e85c6355b1e44597933ccc47a890a4d51b2d9e3b74cc7d9cf0480a5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "60c18032ccec7d5064ba01fc06f930db73fab62ea5f6ac59ace590c572033b44"
  end

  depends_on "openssl@3"

  # Support CXXFLAGS when building on macOS
  # PR ref: https://github.com/rgaufman/live555/pull/46
  # TODO: Remove once changes land in a release
  patch do
    url "https://github.com/rgaufman/live555/commit/16701af5486bb3a2d25a28edaab07789c8a9ce57.patch?full_index=1"
    sha256 "2d98a782081028fe3b7daf6b2db19e99c46f0cadab2421745de907146a3595cb"
  end

  def install
    # "test" was added to std::atomic_flag in C++20
    # See https://github.com/rgaufman/live555/issues/45
    ENV.append "CXXFLAGS", "-std=c++20"

    # Avoid linkage to system OpenSSL
    libs = [
      Formula["openssl@3"].opt_lib/shared_library("libcrypto"),
      Formula["openssl@3"].opt_lib/shared_library("libssl"),
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
