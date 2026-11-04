class Openrtsp < Formula
  desc "Command-line RTSP client"
  homepage "http://www.live555.com/openRTSP"
  url "https://download.live555.com/live.2026.11.04.tar.gz"
  mirror "https://download.videolan.org/pub/videolan/testing/contrib/live555/live.2026.11.04.tar.gz"
  mirror "https://pkg.freebsd.org/ports-distfiles/live.2026.11.04.tar.gz"
  # Keep a mirror as upstream tarballs are removed after each version
  sha256 "67c8b5f51edd04f7580f2a8a7778c125290955991c38d1d54afea49f4762a5e7"
  license "LGPL-3.0-or-later"

  livecheck do
    url "https://download.live555.com/"
    regex(/href=.*?live[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "037ffda3f2d24b2066571dbb1497011b65025b961dbca783af92af620cf30bd5"
    sha256 cellar: :any, arm64_tahoe:       "36b631d214076cf17dc84f304f6f8819bba7e059812b5cc4bc260154a339327a"
    sha256 cellar: :any, arm64_sequoia:     "ade4db6933e494c225d3c8b858e87f602bdf21ee4029618ea1abc32c03237b17"
    sha256 cellar: :any, arm64_linux:       "6300624d3918c3ac05d36d1c7d82b1e64f5a97b0cc900d18597c0023a56c9a23"
    sha256 cellar: :any, x86_64_linux:      "fc4885336362467897020ecd243889a668211f370d4619402ecc181c295d2f6d"
  end

  depends_on "openssl@4"

  deny_network_access!

  def install
    # "test" was added to std::atomic_flag in C++20
    # See https://github.com/rgaufman/live555/issues/45
    ENV.append "CXXFLAGS", "-std=c++20"

    # Avoid linkage to system OpenSSL
    libs = [
      formula_opt_lib("openssl@4")/shared_library("libcrypto"),
      formula_opt_lib("openssl@4")/shared_library("libssl"),
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
