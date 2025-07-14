class Openrtsp < Formula
  desc "Command-line RTSP client"
  homepage "http://www.live555.com/openRTSP"
  url "http://www.live555.com/liveMedia/public/live.2025.07.10.tar.gz"
  mirror "https://download.videolan.org/pub/videolan/testing/contrib/live555/live.2025.07.10.tar.gz"
  # Keep a mirror as upstream tarballs are removed after each version
  sha256 "a8351334db684f7850e61b6f40636c2bda4eb00e114b2707defd0c2328d3f1ec"
  license "LGPL-3.0-or-later"

  livecheck do
    url "http://www.live555.com/liveMedia/public/"
    regex(/href=.*?live[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "129278f4fd9720089133c4952039da4adaa4833dc1573df3b4c44cb317bc173b"
    sha256 cellar: :any,                 arm64_sonoma:  "f47b4a7ee7c7130b34eaa6a02097237b952f067f2dff7311a32979b92f7e465a"
    sha256 cellar: :any,                 arm64_ventura: "92d92818b9ae8d2cca4d821adb502b4273c23c3596cef374e586f418b44579bb"
    sha256 cellar: :any,                 sonoma:        "e5f297b3ed5f8608e3c280cf285710747dcbece11b832ed82cf1b0930a6e164d"
    sha256 cellar: :any,                 ventura:       "9d8be4cc4967582e262f2556ac93b41246f82249cca97e287a19134656ddbc02"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c055e55a29c6f09c59c4451c52953ac70937f92a61ec2bff60853596c2783fdb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2ad9ba5cb65cff40ee0a27a56859de48c62587df0a5471a99ba08c5ec59e3fbc"
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
