class Openrtsp < Formula
  desc "Command-line RTSP client"
  homepage "http://www.live555.com/openRTSP"
  url "http://www.live555.com/liveMedia/public/live.2025.09.17.tar.gz"
  mirror "https://download.videolan.org/pub/videolan/testing/contrib/live555/live.2025.09.17.tar.gz"
  # Keep a mirror as upstream tarballs are removed after each version
  sha256 "bc8a449deb7d027d7b16f469e5dd7ecc995e41067dd2b479c7f0b433cac8eb66"
  license "LGPL-3.0-or-later"

  livecheck do
    url "http://www.live555.com/liveMedia/public/"
    regex(/href=.*?live[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "69eaa6fb4af89e94c13bc51c2e4149ecb048ba676af25c231ab2051d66a7ad06"
    sha256 cellar: :any,                 arm64_sequoia: "b672579e8ce462a388f403c6baed9b5abae96cc86181898cc957bb7e94011def"
    sha256 cellar: :any,                 arm64_sonoma:  "5e97460971c679e1767c00381b2bee7f5cb027dea304428d51d354c7ba9afec6"
    sha256 cellar: :any,                 sonoma:        "8f32b7866c84d51526afb86a9988e415e119b96fced8ec12ae57816142bfcdac"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e4a4b38dca6762c225c06b4d63b963e29d18107bb51d3f787873f3049d351ec9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4fd699401ca9cbe2d2ec186f5a748529343f7b2cb04915851008ae60886f2612"
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
