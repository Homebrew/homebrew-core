class Openrtsp < Formula
  desc "Command-line RTSP client"
  homepage "http://www.live555.com/openRTSP"
  url "http://www.live555.com/liveMedia/public/live.2024.03.08.tar.gz"
  mirror "https://download.videolan.org/pub/videolan/testing/contrib/live555/live.2024.03.08.tar.gz"
  # Keep a mirror as upstream tarballs are removed after each version
  sha256 "c16502e046f1c5f2be3b15e2c8d6cd30639b54c64ea9bfbc8d31b4efca670de5"
  license "LGPL-3.0-or-later"

  livecheck do
    url "http://www.live555.com/liveMedia/public/"
    regex(/href=.*?live[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "4b0712a05c4f636d9e7d71ebe475eb105f36778d6add3e701eb549cd369c7f47"
    sha256 cellar: :any,                 arm64_ventura:  "bca989ef04b2bea0bcf26297c88f914c961caf723726bdf1b41034934bf74683"
    sha256 cellar: :any,                 arm64_monterey: "0e349f2d939fbd653e70ab3838af93ec0920335939b3dec6b0658c7495672ce1"
    sha256 cellar: :any,                 sonoma:         "6ffc0f6a031a175e63f32a00e50b90358137de845d0dd05a599f8834d580829b"
    sha256 cellar: :any,                 ventura:        "0bfdbf1caa5990035e0985bcf67afebe7636b2265938618ad1a3b9df6de8a4a9"
    sha256 cellar: :any,                 monterey:       "6504451d037d82f62a21111745db8d7665ae211d143691138b8a09769ff42941"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ae137f327e5ad4321005355f5b55c1ada8e7c82df4984778e2045f8739f232b8"
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
