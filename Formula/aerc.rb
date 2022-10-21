class Aerc < Formula
  desc "Email client that runs in your terminal"
  homepage "https://aerc-mail.org/"
  url "https://git.sr.ht/~rjarry/aerc/archive/0.13.0.tar.gz"
  sha256 "d8717ab2c259699b6e818a8f8db1e24033a2e09142e2e9b873fa5de6ee660bd8"
  license "MIT"
  head "https://git.sr.ht/~rjarry/aerc", branch: "master"

  bottle do
    sha256 arm64_monterey: "7e950c3cce4909d99394eb76821bca228f839be7db11972f904a7016c4db5c95"
    sha256 arm64_big_sur:  "9e8556b232c0eb5c1e3380b4e66fa9a863045a2bd36c290c5c0fa7666448b236"
    sha256 monterey:       "5a858ba8f12e05400fe74fb758f84d1ba27c11e2beaf2cfd351428069092e02a"
    sha256 big_sur:        "bfaa2b622c1fb64f9456bca1c21abc3954a83d5b213c8743d546aeff5721fa83"
    sha256 catalina:       "1e1e2fa4f79b307bea0a5529076812ee214d4f887103f3343f5d7572506c2a93"
    sha256 x86_64_linux:   "dad1181d18b424e56ccfa701c2ab0d7b78e639ce0d62882c8a46e462aca5e65a"
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
