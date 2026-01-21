class Openrtsp < Formula
  desc "Command-line RTSP client"
  homepage "http://www.live555.com/openRTSP"
  # Keep a mirror as upstream tarballs are removed after each version
  url "https://download.videolan.org/pub/videolan/testing/contrib/live555/live.2026.01.12.tar.gz"
  mirror "https://pkg.freebsd.org/ports-distfiles/live.2026.01.12.tar.gz"
  mirror "http://www.live555.com/liveMedia/public/live.2026.01.12.tar.gz"
  sha256 "2c54c2e090065849d0ab8cc7b06942f4e66dde17f2a0c80ae20b907d562c937e"
  license "LGPL-3.0-or-later"

  livecheck do
    url "http://www.live555.com/liveMedia/public/"
    regex(/href=.*?live[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "2d80f5b0b9470cb64a17249ef166b521b5b455dcf02638a895dde88004ed9e8e"
    sha256 cellar: :any,                 arm64_sequoia: "a95d99e0e0917de3de4cb610cd7fda0f54ab3237aedcc898371de410bba861e8"
    sha256 cellar: :any,                 arm64_sonoma:  "3514e56158017f85e50f6bc8b255cf0713d7ae809a8cbb1b332eec3c8e21139a"
    sha256 cellar: :any,                 sonoma:        "deda715fc7e2ed5ed5b056b5d5b8f48bed4384a851127c15d96fd206b839f30c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b67f9620f90a03dee5dec1360c893be589f547964a5d825a4e3a6a48e4eb165d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "45ff41ec132694df1fc20dc81e1eba9b82de5e85211761ae803e48dd40baf94a"
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
