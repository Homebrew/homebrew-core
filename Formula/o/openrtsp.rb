class Openrtsp < Formula
  desc "Command-line RTSP client"
  homepage "http://www.live555.com/openRTSP"
  url "https://download.live555.com/live.2026.02.26.tar.gz"
  mirror "https://download.videolan.org/pub/videolan/testing/contrib/live555/live.2026.02.26.tar.gz"
  mirror "https://pkg.freebsd.org/ports-distfiles/live.2026.02.26.tar.gz"
  # Keep a mirror as upstream tarballs are removed after each version
  sha256 "ef865566b75bf02f19696bfa8c7db01ffe8c629e321b64162b26554dead2f545"
  license "LGPL-3.0-or-later"

  livecheck do
    url "https://download.live555.com/"
    regex(/href=.*?live[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "5a919d20f383a7ea9e80143e7b93f22393f6c6a1aec0da2cbc17b90acc8cf52f"
    sha256 cellar: :any,                 arm64_sequoia: "ebfb8888a648ec098a945f7b9ed2140088ac6ad91223338966ec6b8c537575f6"
    sha256 cellar: :any,                 arm64_sonoma:  "d66d4e55d73e706d9a2786d420e34dfcf97d9fc8b0537c856ef826d65893fa2d"
    sha256 cellar: :any,                 sonoma:        "03dcfe82ad6d040065f9bb7178db9a4f4687d0e035fa16543705597d9cf5c9fd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ddeb949ddc0351b3ad08b98e3543c4f0643cd7ee54cf21f9d02eb991ebdeab7a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7d9e9390defb1d3c52013f9f9581b392d791be378127a658d99dc3a41f1f3957"
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
