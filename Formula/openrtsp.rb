class Openrtsp < Formula
  desc "Command-line RTSP client"
  homepage "http://www.live555.com/openRTSP"
  url "http://www.live555.com/liveMedia/public/live.2022.01.06.tar.gz"
  mirror "https://download.videolan.org/pub/videolan/testing/contrib/live555/live.2022.01.06.tar.gz"
  # Keep a mirror as upstream tarballs are removed after each version
  sha256 "b6bfdaa51f1398c57c8d16bd389b9da776a13bd7c066ca8be6999822ac02e087"
  license "LGPL-3.0-or-later"

  livecheck do
    url "http://www.live555.com/liveMedia/public/"
    regex(/href=.*?live[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_monterey: "577e36973372aacc4244bbfff382a2c5e5c1caa76976211183d227af02194d96"
    sha256 cellar: :any, arm64_big_sur:  "9f78bd11f27b43e1ce837d91baeecab3e6be234b9ccc7ebd9f1661085b3ffd4b"
    sha256 cellar: :any, monterey:       "3aa9d30b5aa7b2155b0d84f6ec2dfdde8be724bf0bd3f6027c85894e3390ea30"
    sha256 cellar: :any, big_sur:        "1c6f6db4f3b235c45a19d4e7658e00421b25dc275a6b8b57b58c6a42c2aaa7da"
    sha256 cellar: :any, catalina:       "de88b2b8273d6f8284c8cd83f670fd53bfafec6f1ad5eb35a333a6e5775c2f31"
  end

  depends_on "openssl@1.1"

  def install
    # Avoid linkage to system OpenSSL
    libs = [
      Formula["openssl@1.1"].opt_lib/"libcrypto.dylib",
      Formula["openssl@1.1"].opt_lib/"libssl.dylib",
    ]

    system "./genMakefiles", "macosx-no-openssl"
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
