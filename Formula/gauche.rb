class Gauche < Formula
  desc "R7RS Scheme implementation, developed to be a handy script interpreter"
  homepage "https://practical-scheme.net/gauche/"
  url "https://github.com/shirok/Gauche/releases/download/release0_9_10/Gauche-0.9.10.tgz"
  sha256 "0f39df1daec56680b542211b085179cb22e8220405dae15d9d745c56a63a2532"
  license "BSD-3-Clause"
  revision 3

  livecheck do
    url :stable
    strategy :github_latest
    regex(/href=.*?Gauche[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_monterey: "f45d98a92e9ccf661db53a84fd768580848fa8e93733ca2934b426058b0a9589"
    sha256 arm64_big_sur:  "0fac8847033124e7ca5108de62cb3d08a573d8dc33715c911af85a668c50dfef"
    sha256 monterey:       "3173cffb21e9c6929a09fe5623b919241af7c9c6c1d5c606460a5f2dc3540f06"
    sha256 big_sur:        "6edbe6e3edd503033d3feb3ff8a0bd1cfb4c16abbfa15328e2ccdd309656b017"
    sha256 catalina:       "dc953fd8f622b64409d2dc6808d5cfd3828c3a36e5fd4fdbccde6db8529800e1"
    sha256 mojave:         "06bcbbd5523d45e098d3e9f9c3c59d8e4858d66ad63f1cdb08bba8a804a08114"
    sha256 x86_64_linux:   "6078ffcd2dea9f757643dec70b13ac66536c0dfd7f96a8ae1e86b0170c5aea53"
  end

  depends_on "mbedtls@2"

  uses_from_macos "zlib"

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-dependency-tracking",
                          "--enable-multibyte=utf-8"
    system "make"
    system "make", "install"
  end

  test do
    output = shell_output("#{bin}/gosh -V")
    assert_match "Gauche scheme shell, version #{version}", output
  end
end
