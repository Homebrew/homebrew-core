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
    sha256 arm64_big_sur: "2408dd97088d6e58539b83d4ee698e987e404cacca3964025d7c99f09263e421"
    sha256 big_sur:       "8e0b17405a1dabdc6c1869ccb304ded93a02f56d0b98a071b6616552c8b1dba6"
    sha256 catalina:      "f194ba5166062f17c00e48c076828da5c8fa5d97d35f20015d21fb6aea72febc"
    sha256 mojave:        "40c10ff51c0d1af469f749a764a3e5a9a1c0aa25c2174b40ae19671724b17895"
    sha256 x86_64_linux:  "82d802ad818f3d5403480c888085bb5ce7c3e44f1bae84a48a0236fbbf9d8f18"
  end

  depends_on "python@3.10"

  def install
    ENV["PYTHONINTERPRETER"] = Formula["python@3.10"].opt_bin/"python3"

    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking"
    system "make", "install"
  end
end
