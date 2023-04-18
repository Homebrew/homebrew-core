class Aerc < Formula
  desc "Email client that runs in your terminal"
  homepage "https://aerc-mail.org/"
  url "https://git.sr.ht/~rjarry/aerc/archive/0.14.0.tar.gz"
  sha256 "60bfd15e5528a504dd11a03a33a11438ebbac7d5daca46e02d0bdc983adf9012"
  license "MIT"
  head "https://git.sr.ht/~rjarry/aerc", branch: "master"

  bottle do
    sha256 arm64_ventura:  "4d82e434f9093f740dbe9249904f2281dbbbc52d7adc3c4eb386035d7363cad9"
    sha256 arm64_monterey: "fe47f46af9ec45df318129348ba6d86dfb6768ad0d7a4811e42bce3bed17957a"
    sha256 arm64_big_sur:  "8aa875830be479bd486a7041ec1068a9075b85cdcd5810b4057a4f7bb6e7379e"
    sha256 ventura:        "caf93a8e9ed8c1687810487eef729cccb2d1fe31d3a7cf7559672d0be9426114"
    sha256 monterey:       "31b99a17e8c116184c0621b9c36a9a0bbb1d294a8946bfbef0cc025b485b1ffd"
    sha256 big_sur:        "1f93fd8e33f0528e042421c7d485ab70829c48fae0f834d6f7a78ed7fe32e546"
    sha256 x86_64_linux:   "8c38786d43ea9ed35fdbbf8ef01e6a7fb07d74e1b3351397e30c724b2a92726a"
  end

  depends_on "go" => :build
  depends_on "scdoc" => :build

  def install
    system "make", "PREFIX=#{prefix}", "VERSION=#{version}"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    system "#{bin}/aerc", "-v"
  end
end
