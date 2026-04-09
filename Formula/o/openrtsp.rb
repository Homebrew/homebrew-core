class Openrtsp < Formula
  desc "Command-line RTSP client"
  homepage "http://www.live555.com/openRTSP"
  url "https://download.live555.com/live.2026.04.01.tar.gz"
  mirror "https://download.videolan.org/pub/videolan/testing/contrib/live555/live.2026.04.01.tar.gz"
  mirror "https://pkg.freebsd.org/ports-distfiles/live.2026.04.01.tar.gz"
  # Keep a mirror as upstream tarballs are removed after each version
  sha256 "dc84af6faec5342029501a8abe441dcbe0796e29a67a7ad0d61b1a242b2724c3"
  license "LGPL-3.0-or-later"

  livecheck do
    url "https://download.live555.com/"
    regex(/href=.*?live[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "80a2bd3ecb1b77cbe89083771ad4658b1b2dff9c17401e37ca71d2c9c5dae204"
    sha256 cellar: :any,                 arm64_sequoia: "907041681b1251ff4419eda27e3bdfce0c5d4a017806331a8ce6638c95de2155"
    sha256 cellar: :any,                 arm64_sonoma:  "fc34b5d335a90d50f07d360ae8684eac4e723e3874d80a1f4ca820537d73f007"
    sha256 cellar: :any,                 sonoma:        "690eca27141c4e2b24311c65a70bad56f3819c8908131872114d57dedce30586"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5a9598b7937f9840c379f818febbc232e96cebf0acb3b1cf342d82af1e8db22a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2e78efdf7892384e3ba0402fd6904ceacd1597048ea54e6671fce4dba5f76c25"
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
