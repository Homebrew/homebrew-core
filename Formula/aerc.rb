class Aerc < Formula
  desc "Email client that runs in your terminal"
  homepage "https://aerc-mail.org/"
  url "https://git.sr.ht/~rjarry/aerc/archive/0.10.0.tar.gz"
  sha256 "14d6c622a012069deb1a31b51ecdd187fd11041c8e46f396ac22830b00e4c114"
  license "MIT"
  head "https://git.sr.ht/~rjarry/aerc", branch: "master"

  bottle do
    sha256 arm64_monterey: "07b0f639519dfeebab62d97d34e2be7948d7a7eed34c2296200f2753f4e8cb1f"
    sha256 arm64_big_sur:  "7e5b591f483879bace3dc00f675e15aa1b07bc4fdd7af0c913b5d9f884325131"
    sha256 monterey:       "a78fa9e52072723610b91543d8e5a1cf8beccf9ed39247d6564015cdb6e2d929"
    sha256 big_sur:        "a71ff65f4b44d97327fb92ab2cd4f3adb387fe82b546875deeb6e782abdad7d7"
    sha256 catalina:       "9ddcc5a17bd657c13e4fc170d8d48c0c6593fabfefde103c0f31d0a8ad45f753"
    sha256 x86_64_linux:   "57c91eb2697be7bedba392caa3b2594b33ef66167a276ac68aabcd1cc495497d"
  end

  depends_on "go" => :build
  depends_on "scdoc" => :build

  def install
    system "make", "PREFIX=#{prefix}"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    system "#{bin}/aerc", "-v"
  end
end
