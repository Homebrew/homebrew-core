class Minisign < Formula
  desc "Sign files & verify signatures. Works with signify in OpenBSD"
  homepage "https://jedisct1.github.io/minisign/"
  url "https://github.com/jedisct1/minisign/archive/0.11.tar.gz"
  sha256 "74c2c78a1cd51a43a6c98f46a4eabefbc8668074ca9aa14115544276b663fc55"
  license "ISC"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "ea00c91ad2e46d1bd858edc3a909ff02401c5e0fb486a3b1a1c10ae0d4411920"
    sha256 cellar: :any,                 arm64_monterey: "8d3f924d7180fe4b04d9e149691eaa4e08f3abe3c49ad817a551199caf274394"
    sha256 cellar: :any,                 arm64_big_sur:  "50bdf209ebcc5e9079223dc1b47c488423655d154eca277a25269aa8d338dc2a"
    sha256 cellar: :any,                 ventura:        "8db7756e5818d2e65820fff744d2fd6e8bfee4140ffd5e8305c0635e676e2ce4"
    sha256 cellar: :any,                 monterey:       "e9ed09ebebb07156ae2d4872bc6f77ee4ea8b92145354fc83ddbbae028af1da5"
    sha256 cellar: :any,                 big_sur:        "73272eb26875a7b1c219279f91c1e97c24f5343bc28698e0adf190cdfbb611f5"
    sha256 cellar: :any,                 catalina:       "6ef7ba174b48584911276e6491dea599b5e84f3747d2f25753c7b36b55ce3b3c"
    sha256 cellar: :any,                 mojave:         "9340a13b895807ec4dbfced552ec3a612a5dbcc88b64b363aef876ec57a4ae4a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "932f5e7be0cb17788c687f8c474363a2acdbfb1b33041ba8c7d9781dde1d2353"
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
