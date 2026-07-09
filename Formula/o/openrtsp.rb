class Openrtsp < Formula
  desc "Command-line RTSP client"
  homepage "http://www.live555.com/openRTSP"
  url "https://download.live555.com/live.2026.07.08.tar.gz"
  mirror "https://download.videolan.org/pub/videolan/testing/contrib/live555/live.2026.07.08.tar.gz"
  mirror "https://pkg.freebsd.org/ports-distfiles/live.2026.07.08.tar.gz"
  # Keep a mirror as upstream tarballs are removed after each version
  sha256 "2e56491e6b5359a3f2cde89a693c01fb312cc279b6da1362194e4cb6c7cdfa35"
  license "LGPL-3.0-or-later"

  livecheck do
    url "https://download.live555.com/"
    regex(/href=.*?live[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "64f756bb22988c942972d6e2346cf3980110f18beb7d6b1f2699be5c036b079f"
    sha256 cellar: :any, arm64_sequoia: "c72c315f1324ace45999d145f8e062e3b2eaac558df4be4d2d318eabf6516cc6"
    sha256 cellar: :any, arm64_sonoma:  "bb348691152248a7a8a37b89437eece99c6214e55ca026af654d0ab7f1f11721"
    sha256 cellar: :any, sonoma:        "c5ae519238738217bd6e61264a26f07ea992c3f2d16d3d7652dac297a0581073"
    sha256 cellar: :any, arm64_linux:   "764be10ee12f9daa9c738a9b152eee86182cd50ae00c92673fc6fc78999cd9fa"
    sha256 cellar: :any, x86_64_linux:  "807e342f98f7009a972004485e7152f69d2713b84eb4008b0ddadb311341e2a0"
  end

  depends_on "openssl@3"

  def install
    # "test" was added to std::atomic_flag in C++20
    # See https://github.com/rgaufman/live555/issues/45
    ENV.append "CXXFLAGS", "-std=c++20"

    # Avoid linkage to system OpenSSL
    libs = [
      formula_opt_lib("openssl@3")/shared_library("libcrypto"),
      formula_opt_lib("openssl@3")/shared_library("libssl"),
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
