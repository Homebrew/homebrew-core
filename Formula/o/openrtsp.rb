class Openrtsp < Formula
  desc "Command-line RTSP client"
  homepage "http://www.live555.com/openRTSP"
  url "http://www.live555.com/liveMedia/public/live.2024.08.01.tar.gz"
  mirror "https://download.videolan.org/pub/videolan/testing/contrib/live555/live.2024.08.01.tar.gz"
  # Keep a mirror as upstream tarballs are removed after each version
  sha256 "839ab7437d01e629f8094ea1ec8c7a7bb504c7deed9edfc9e17ac34f9a1a193f"
  license "LGPL-3.0-or-later"

  livecheck do
    url "http://www.live555.com/liveMedia/public/"
    regex(/href=.*?live[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "32018d3190c13a3c2aa3c3dff8ea864615e735b907883536f4f63231697d51e3"
    sha256 cellar: :any,                 arm64_ventura:  "d47acb05ac38decc4e595cc1ab4c02cb643b81848a7d645db4d2322923509f85"
    sha256 cellar: :any,                 arm64_monterey: "58bbf2ec6d6876a2a9603802bcd9b3a448ecd0841a29ecfbd9fd632bd6ff96c1"
    sha256 cellar: :any,                 sonoma:         "1d97f88721867def6f98c570eb1b03a56a28d8e3bde891e003554750031917d3"
    sha256 cellar: :any,                 ventura:        "b77dccc41e3a905ab3c175fe3323d8c7b71774e4febb5fa1df568199e155ac10"
    sha256 cellar: :any,                 monterey:       "0c56e3d71bb6f7fcd208430835187c098ec7924ba7671c3295c6a9edc88f0e21"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d7303ab03346d32fc2521879e02b44533ca28e1cca42ea4db316fa7ffbeb3dee"
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
