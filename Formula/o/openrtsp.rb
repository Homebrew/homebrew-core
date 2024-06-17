class Openrtsp < Formula
  desc "Command-line RTSP client"
  homepage "http://www.live555.com/openRTSP"
  url "http://www.live555.com/liveMedia/public/live.2024.05.30.tar.gz"
  mirror "https://download.videolan.org/pub/videolan/testing/contrib/live555/live.2024.05.30.tar.gz"
  # Keep a mirror as upstream tarballs are removed after each version
  sha256 "8550b06d8d54c0075f80e95ef6742a9dc677fcafc2dbb8247f03832fb9ad564f"
  license "LGPL-3.0-or-later"

  livecheck do
    url "http://www.live555.com/liveMedia/public/"
    regex(/href=.*?live[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "efae17159bbadd46625612c89c644d94de0a35765eb6db5c01bc9e37c7b8ced4"
    sha256 cellar: :any,                 arm64_ventura:  "86b4dce50ee3263ad4348bac0e5d01718b10819dc401fbc61d5ea62fe091dd12"
    sha256 cellar: :any,                 arm64_monterey: "0cc47028d5eb8b741322e871b2cc568faf063bbe806746e60c741bc178fb3428"
    sha256 cellar: :any,                 sonoma:         "33a324100cb1abd02dbd787cadf3c162223805a98f00f4dd719af9a10d54ddee"
    sha256 cellar: :any,                 ventura:        "517721dea85db06c98a4d1d3c7bf6c46b67724de2b9eca2f3e4bdc1def7e4cf4"
    sha256 cellar: :any,                 monterey:       "e27cdab3814e02048d49f193e48c6bf5a1373d28b1b76d3cef0023f987b29e83"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "734eb8cdff912f04757504c87d1c555f0c53bc62ab0c7fd1a909cbfe77064397"
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
