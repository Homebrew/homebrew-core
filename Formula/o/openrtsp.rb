class Openrtsp < Formula
  desc "Command-line RTSP client"
  homepage "http://www.live555.com/openRTSP"
  url "http://www.live555.com/liveMedia/public/live.2025.05.24.tar.gz"
  mirror "https://download.videolan.org/pub/videolan/testing/contrib/live555/live.2025.05.24.tar.gz"
  # Keep a mirror as upstream tarballs are removed after each version
  sha256 "e6185902c4bfe9235067a0bc80ec9a5f8a95956d9d07525ce169f3f9753afb0a"
  license "LGPL-3.0-or-later"

  livecheck do
    url "http://www.live555.com/liveMedia/public/"
    regex(/href=.*?live[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "e69170b556c5e05160447fd39f1c8bdb0897a506fa4e16bfca7ba12d47d27249"
    sha256 cellar: :any,                 arm64_sonoma:  "6b10e40812f57dd7a78c01c6f800a6a549f6a6075943fed6bbfed1431a008461"
    sha256 cellar: :any,                 arm64_ventura: "661a188848cae2726baec08fa8f6a7086d839cf8be1d83beda0a0644f120a6c9"
    sha256 cellar: :any,                 sonoma:        "0f5a0b7b8e76f47bbdb782eca0b42a6940e0d57103282a3b9778c6380aff35ee"
    sha256 cellar: :any,                 ventura:       "a30408fa4660532d67ade3cba78c89cb11f42e96f9dd9da25c58bcf0e7cdc02f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1b074bc59b3b881ddb37d993a8bb349d6b8246ca83bed44532f43f79d5ff5ee0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "417da9b953a5b52983b4e2da5688af6eafe1864dda470bab78465d2aefe80637"
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
