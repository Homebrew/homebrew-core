class Jailkit < Formula
  desc "Utilities to create limited user accounts in a chroot jail"
  homepage "https://olivier.sessink.nl/jailkit/"
  url "https://olivier.sessink.nl/jailkit/jailkit-2.23.tar.bz2"
  sha256 "aa27dc1b2dbbbfcec2b970731f44ced7079afc973dc066757cea1beb4e8ce59c"
  license all_of: ["BSD-3-Clause", "LGPL-2.0-or-later"]
  revision 1

  livecheck do
    url :homepage
    regex(/href=.*?jailkit[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_monterey: "84057794afa5db7583d6787a3b6e246257efc8bbf6601566771265228084bdef"
    sha256 arm64_big_sur:  "e9a582fee1859d32410b20dff031b55c1a0a72862b8422cb8299800832977f16"
    sha256 monterey:       "d8059ea2e2f6dce16220b99d43dea5adebc200a80e98f4b8017b0efe8c29c6d7"
    sha256 big_sur:        "7f9fe097188c70df7933bd30d6c78c60455355df8e33a3ad4927002cf70ec2e9"
    sha256 catalina:       "35d7f20d16725ad3ec24dd82592a0fc7ae2e1cfc0b6bf3eaaf04e8118437ca09"
    sha256 mojave:         "9ae118d16ab03810384fb708caf5fcf4429c209c147e40f03f08a45b8c24138d"
    sha256 x86_64_linux:   "fe136070c9a808323d6919365991597aaf5f2ca6867d8cee66129c205943a8e2"
  end

  depends_on "python@3.10"

  def install
    ENV["PYTHONINTERPRETER"] = Formula["python@3.10"].opt_bin/"python3"

    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking"
    system "make", "install"
  end
end
