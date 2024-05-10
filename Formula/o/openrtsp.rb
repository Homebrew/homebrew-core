class Openrtsp < Formula
  desc "Command-line RTSP client"
  homepage "http://www.live555.com/openRTSP"
  url "http://www.live555.com/liveMedia/public/live.2024.05.05.tar.gz"
  mirror "https://download.videolan.org/pub/videolan/testing/contrib/live555/live.2024.05.05.tar.gz"
  # Keep a mirror as upstream tarballs are removed after each version
  sha256 "8c64f58e0e696b86f021cc54cbbfecbc8854d870b1c764cd3245af05f377de73"
  license "LGPL-3.0-or-later"

  livecheck do
    url "http://www.live555.com/liveMedia/public/"
    regex(/href=.*?live[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "fab4a634c2513ae692d61d6c0de9a772420a9deb81948a50a6b20e69230b782c"
    sha256 cellar: :any,                 arm64_ventura:  "5925c6dbf34e7b6b154566f4a5746c422101e3b5f3c1c586ba926b6bbdfab728"
    sha256 cellar: :any,                 arm64_monterey: "51ea2154fee9d96e7f450381e11b04727cf75e872beb50ace323f22b5d069035"
    sha256 cellar: :any,                 sonoma:         "7aac479c9223696a9d85ee672e9f06e5c08029942fa7b77e07619770e8d3d787"
    sha256 cellar: :any,                 ventura:        "33a4c629310b236052704dd7bbdfe611f89c533224a14ad9bd9f6699b22eebee"
    sha256 cellar: :any,                 monterey:       "8e06c8fad2fe3096cec2a174312c3d9e9fab123b53302121a57c26bd5530a78a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f0a7bbfb10c2bc4aefab65dc88fc691637379d593b4927c9c1db67fc7effef40"
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
