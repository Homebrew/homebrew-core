class Aerc < Formula
  desc "Email client that runs in your terminal"
  homepage "https://aerc-mail.org/"
  url "https://git.sr.ht/~rjarry/aerc/archive/0.8.1.tar.gz"
  sha256 "5bea713b211dcd85599c697a0f6563e07e2c04fd1443416545eea0a9a83a4f8d"
  license "MIT"
  head "https://git.sr.ht/~rjarry/aerc", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "502a4d7bd81afa858719d02d93eb32378b9d7702b704d40fd3bbd6ced996d2c2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "200c8c27f08e0e7060eb4cf417eb984fb7cc73f4b2daecb66b8f5d54128159f4"
    sha256 cellar: :any_skip_relocation, monterey:       "6d537f0f3f21f76ac36097b670c55c019304195bd6478a9705ece8232f143fd5"
    sha256 cellar: :any_skip_relocation, big_sur:        "b9386f12b6883a7a8b69e06ee2f25344a2f6a1040b5bedc5fd860d011b9aceba"
    sha256 cellar: :any_skip_relocation, catalina:       "d8e674c173654a573b464804abfb9950f66ffda46b1a611010bce6f1c85f09a3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "502657f907934fd7caa1babc8147b3fac7ccf8ab30b9f94479bbdb4f2e0a112e"
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
