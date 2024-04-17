class Openrtsp < Formula
  desc "Command-line RTSP client"
  homepage "http://www.live555.com/openRTSP"
  url "http://www.live555.com/liveMedia/public/live.2024.04.14.tar.gz"
  mirror "https://download.videolan.org/pub/videolan/testing/contrib/live555/live.2024.04.14.tar.gz"
  # Keep a mirror as upstream tarballs are removed after each version
  sha256 "991e6b2862ad4f032ade9fb100019da340cd36721ee0a1e569d2cf96785584d6"
  license "LGPL-3.0-or-later"

  livecheck do
    url "http://www.live555.com/liveMedia/public/"
    regex(/href=.*?live[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "b2c470c0a01858cf52baf5d8c7a90bff103faec6baf81e33738a85078e66f6a3"
    sha256 cellar: :any,                 arm64_ventura:  "48c3f0d8a95e0fa984b1961a6cc02d80b59fb4ae0011943939ca84beea53f88d"
    sha256 cellar: :any,                 arm64_monterey: "5517f64201eeae548c4079e216917e328be4885cc2723cfda97937f9aa44c1f2"
    sha256 cellar: :any,                 sonoma:         "8f2fdf028740dd162d7899e7c1de70e8d538f0f94519c67436e59a9f01b5d0ec"
    sha256 cellar: :any,                 ventura:        "f96543fbf415d56a4ccfeeb0a137d92da13c79eafd799688762a9c148c8b5320"
    sha256 cellar: :any,                 monterey:       "c4cd80b3153102a600a5a3fc3d9eafe94de23036f9c47221518fca21c68ac886"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c4561aa83df1ef617ea6b472d0a42a41da2d597a2a7242ffe536579810684e8d"
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
