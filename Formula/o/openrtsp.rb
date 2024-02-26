class Openrtsp < Formula
  desc "Command-line RTSP client"
  homepage "http://www.live555.com/openRTSP"
  url "http://www.live555.com/liveMedia/public/live.2024.02.23.tar.gz"
  mirror "https://download.videolan.org/pub/videolan/testing/contrib/live555/live.2024.02.23.tar.gz"
  # Keep a mirror as upstream tarballs are removed after each version
  sha256 "f392565dfb0f02fa1c5f93e2297c3d5e4778ce6d9a933c4c7844ec677c66db08"
  license "LGPL-3.0-or-later"

  livecheck do
    url "http://www.live555.com/liveMedia/public/"
    regex(/href=.*?live[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "a05c97fde34d8eaab7e51ce4fd033a789038540bb1a57a89e3bdabf982e9c183"
    sha256 cellar: :any,                 arm64_ventura:  "f9c986e52b8f122535400fb77b11efcdfc016e3f65457a0adfc555921754cf46"
    sha256 cellar: :any,                 arm64_monterey: "fd81c2eef1539329a0c0b1528168b0fa09683d0d47b00c3a02c21c0b4c636546"
    sha256 cellar: :any,                 sonoma:         "e0a74479599b3ddfd948459b368d481662dfefadc9a6ad5180c450139be41f31"
    sha256 cellar: :any,                 ventura:        "58283f87086d9a3f832975cde6f94e7de0eb75e76251a00827f67821ed8c4777"
    sha256 cellar: :any,                 monterey:       "e4e1be758a2921fe9d34a1cf97d71301ca2841ae0352a17445aa78cedabfa006"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "eaeb89db6b627fce36514c789c94402b86269714bc0aca47845d182963ffed50"
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
