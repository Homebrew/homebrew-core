class Openrtsp < Formula
  desc "Command-line RTSP client"
  homepage "http://www.live555.com/openRTSP"
  url "http://www.live555.com/liveMedia/public/live.2023.07.24.tar.gz"
  mirror "https://download.videolan.org/pub/videolan/testing/contrib/live555/live.2023.07.24.tar.gz"
  # Keep a mirror as upstream tarballs are removed after each version
  sha256 "2e2225678f6284ade93ba8558dc5a3e53c844408fc1944571175369e060551ce"
  license "LGPL-3.0-or-later"

  livecheck do
    url "http://www.live555.com/liveMedia/public/"
    regex(/href=.*?live[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "705eb8e93a13b5b74603ef326e48d935029e568d3d54ddc5f88734607b928995"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ccc61de8ab0ebf1991189e0756a378759fb3b23b67eb085636975cf55323e222"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "91bc26e0dae15b0ac097ab10faef3aba58df5b7bd037fcf85eea740469199834"
    sha256 cellar: :any_skip_relocation, ventura:        "720784246e3ad127f0338809fbacef2ae31ab41bb34fa634c69cc9ff302908d2"
    sha256 cellar: :any_skip_relocation, monterey:       "31bc17063c1d2cf7c213f7105df18197bf653d6a7cbfb2c4b7f1c7aaedc0aad7"
    sha256 cellar: :any_skip_relocation, big_sur:        "73d9d2dfc5c6a9a016e0818e932041893329f4ae814f634a1ae1b56a245b5d9b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "068d83d49b4cdf79582475c2778d342041a8cd83ce8f658524bf602a670e705e"
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
