class Openrtsp < Formula
  desc "Command-line RTSP client"
  homepage "http://www.live555.com/openRTSP"
  url "https://download.live555.com/live.2026.02.13.tar.gz"
  mirror "https://download.videolan.org/pub/videolan/testing/contrib/live555/live.2026.02.13.tar.gz"
  mirror "https://pkg.freebsd.org/ports-distfiles/live.2026.02.13.tar.gz"
  # Keep a mirror as upstream tarballs are removed after each version
  sha256 "5f0b16574a5aec8921c782981e87be4e5224eb5c5036b30a3a02aea49157025f"
  license "LGPL-3.0-or-later"

  livecheck do
    url "https://download.live555.com/"
    regex(/href=.*?live[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "42ae9387ef0c31bdb3ded40b816b6274912bc5dab8b7ff18f1c6f7d3da1986ac"
    sha256 cellar: :any,                 arm64_sequoia: "87c458af30a61101de68708336613e536caa861b5b05686f94d75d697b7cf9c2"
    sha256 cellar: :any,                 arm64_sonoma:  "60acc1bbdce4310526241db8baf2aba57b780926de1cbd2d0f753584e9b65a9e"
    sha256 cellar: :any,                 sonoma:        "21137ee41b34401eae468b39257d98f0dc81def0ce4c6550332727d0f4c64b73"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6969607cb8ba5f84ec11d32371f1ad8131d53092714d3ac859669f7c42332e9c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f865eb66646d1c8207c093a20e1dd93cdd740994165a98734acdfb66806887dd"
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
