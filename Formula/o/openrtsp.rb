class Openrtsp < Formula
  desc "Command-line RTSP client"
  homepage "http://www.live555.com/openRTSP"
  url "http://www.live555.com/liveMedia/public/live.2025.04.24.tar.gz"
  mirror "https://download.videolan.org/pub/videolan/testing/contrib/live555/live.2025.04.24.tar.gz"
  # Keep a mirror as upstream tarballs are removed after each version
  sha256 "a34a17e8c0922097bcd1fae6d5b42a6d75d493266a4f4a6f11dc0b4c3351a6f6"
  license "LGPL-3.0-or-later"

  livecheck do
    url "http://www.live555.com/liveMedia/public/"
    regex(/href=.*?live[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "273d91a585a8730de9017cabede57a9925b4c7f89580d3c09812117baefff81c"
    sha256 cellar: :any,                 arm64_sonoma:  "45a767e8183101a63e97a5d7b465515fbae6a8beb89c2ce6d22d9e9391065797"
    sha256 cellar: :any,                 arm64_ventura: "9d3870e7428d1ab49a77096ba18b3bbd8e67edd53d1cb5d1297872f1a894e2e9"
    sha256 cellar: :any,                 sonoma:        "01fe90df1e0bff0cf2b0865d21a22d72d3507b1d94945c9c52d6416f5ca4a52c"
    sha256 cellar: :any,                 ventura:       "21439dd2d75eb60c35b5e4860d7b250700be31e633ed607d76b7889ace7c1c4e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "029d276cdfc068d07ef7cd8b98731df2b16cf7451de2d153dbbe790ebb3cb772"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e08dd5c2b15d95bed03d21d5f3001d22890c3561916ad0895155393d1dc70c9a"
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
