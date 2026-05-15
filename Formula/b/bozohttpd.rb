class Bozohttpd < Formula
  desc "Small and secure http version 1.1 server"
  homepage "https://pkgsrc.se/www/bozohttpd"
  url "https://cdn.netbsd.org/pub/pkgsrc/distfiles/LOCAL_PORTS/bozohttpd-20260503.tar.bz2"
  sha256 "2a2e6d62b68d219434973937a8febd17741f22e98c741f6c922b22f13f7523cd"
  license "BSD-2-Clause"

  livecheck do
    url "https://cdn.netbsd.org/pub/pkgsrc/distfiles/"
    regex(/href=.*?bozohttpd[._-]v?(\d+(?:\.\d+)*)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "a4226ca0417b3a42426e8b9c66e35c27e5b33cde093b72b6367bd4e9af8bf3f5"
    sha256 cellar: :any,                 arm64_sequoia: "a8bbb72a39b43114431d8fe63bb84828f3c07d1f3874642bde1d7e60ae84777d"
    sha256 cellar: :any,                 arm64_sonoma:  "867d0c4eac9ad4783a5c137d51dbeaa069c632cf0103e6e16a108dcff3fff849"
    sha256 cellar: :any,                 sonoma:        "798fb50a66dfd8336989103f0dfd6b238421a71d3b8741252c0c247c90d5d8e3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "89de2d92f7e7e9b270ec5df6c83802901c70ddf5db3153f653cc2a10e70a02ba"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3c755a16e29068de4b39e08aece48a14ac58d95252e205d428b794ae26fad71a"
  end

  depends_on "openssl@4"

  def install
    system "make", "-f", "Makefile.boot", "CC=#{ENV.cc}"
    bin.install "bozohttpd"
  end

  test do
    port = free_port

    expected_output = "Hello from bozotic httpd!"
    (testpath/"index.html").write expected_output

    spawn bin/"bozohttpd", "-b", "-f", "-I", port.to_s, testpath
    assert_match expected_output, shell_output("curl --silent --retry 5 --retry-connrefused 127.0.0.1:#{port}")
  end
end
