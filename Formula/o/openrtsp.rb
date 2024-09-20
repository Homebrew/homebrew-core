class Openrtsp < Formula
  desc "Command-line RTSP client"
  homepage "http://www.live555.com/openRTSP"
  url "http://www.live555.com/liveMedia/public/live.2024.09.20.tar.gz"
  mirror "https://download.videolan.org/pub/videolan/testing/contrib/live555/live.2024.09.20.tar.gz"
  # Keep a mirror as upstream tarballs are removed after each version
  sha256 "4eb52778219a249c42f8680bd5967f65c38d7aa0c7d39069e38ff79640acf6d8"
  license "LGPL-3.0-or-later"

  livecheck do
    url "http://www.live555.com/liveMedia/public/"
    regex(/href=.*?live[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "888ca31bf4867ce896852a326b536712b69405fff8eb578a6e577cd8436ebc95"
    sha256 cellar: :any,                 arm64_sonoma:  "f81d38db7f3c25801f832570d1161dfdaaae2a6134c6a72c77e9f87d434aec28"
    sha256 cellar: :any,                 arm64_ventura: "8eb602fd4d8338640c63d28d7c455cbbe853db78a71627c969b9205758842024"
    sha256 cellar: :any,                 sonoma:        "e8b36fa5771ce722ca5d1eb8a93af28c697e9117c9d7089187a5b9bc85d7ef07"
    sha256 cellar: :any,                 ventura:       "11728dc9ba36b08f0ec7e91a3e655f46e3a90884b0e62e9f737001e94fb7630f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7ea4323f070aeccf6f878dab9629958f61d3f5af45262602ccfdf99358d5e0e7"
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
