class Minisign < Formula
  desc "Sign files & verify signatures. Works with signify in OpenBSD"
  homepage "https://jedisct1.github.io/minisign/"
  url "https://github.com/jedisct1/minisign/archive/refs/tags/0.11.tar.gz"
  sha256 "74c2c78a1cd51a43a6c98f46a4eabefbc8668074ca9aa14115544276b663fc55"
  license "ISC"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "f0ac0fea74f76a2386da2de3c7faf6f757686ae623dc88f9eb1f4e4eecbe58ec"
    sha256 cellar: :any,                 arm64_sonoma:   "15bb5196196433571ebaf41afe8005ea47912d16dafe3c2d4fa4d2e0e18fc9a5"
    sha256 cellar: :any,                 arm64_ventura:  "a81fea50d53645c045ab117414f4aa99567bc38fe735f48766956d82e29eec5d"
    sha256 cellar: :any,                 arm64_monterey: "45006c92f229303c788dd4b73bc5c3872c88eddb127fd75b508f9e8c356d2ebe"
    sha256 cellar: :any,                 sonoma:         "c9757b400301bec4203e95955c7ce34be0e6f54039b77bd470b97a05feba7dd4"
    sha256 cellar: :any,                 ventura:        "9daec2dcc65faacb0d701749a16d354c72a2426fe951b0d9b275281e17a881ef"
    sha256 cellar: :any,                 monterey:       "dc38390b76728747a95b3675094ef600b564467ce2c390229e8dd1cbeb7f10fb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2a0a5c0e17f95961134b996c04fc60d978a53abd2835f88a326aebfffcb66cc0"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "libsodium"

  uses_from_macos "expect" => :test

  def install
    system "cmake", ".", *std_cmake_args
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"homebrew.txt").write "Hello World!"
    (testpath/"keygen.exp").write <<~EOS
      set timeout -1
      spawn #{bin}/minisign -G
      expect -exact "Please enter a password to protect the secret key."
      expect -exact "\n"
      expect -exact "Password: "
      send -- "Homebrew\n"
      expect -exact "\r
      Password (one more time): "
      send -- "Homebrew\n"
      expect eof
    EOS

    system "expect", "-f", "keygen.exp"
    assert_predicate testpath/"minisign.pub", :exist?
    assert_predicate testpath/".minisign/minisign.key", :exist?

    (testpath/"signing.exp").write <<~EOS
      set timeout -1
      spawn #{bin}/minisign -Sm homebrew.txt
      expect -exact "Password: "
      send -- "Homebrew\n"
      expect eof
    EOS

    system "expect", "-f", "signing.exp"
    assert_predicate testpath/"homebrew.txt.minisig", :exist?
  end
end
