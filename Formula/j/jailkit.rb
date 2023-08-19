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
    rebuild 1
    sha256 arm64_ventura:  "d4ad9733baab3fffc9088d56aa10070bb6954e91f452ae180ef1b57112a5dd06"
    sha256 arm64_monterey: "4adb29e6f715ccb71dd1b14b38710018dc9545f67fd81f028b79352dd438a8a1"
    sha256 arm64_big_sur:  "7ea538f86542cab83e908386d08747b6d4f16ba86101f211f00bfa24a5da97a6"
    sha256 ventura:        "b8a74b851cdcbaf0fb122038520fbcdcdbd661418eb4ddf907896a22f7b9e232"
    sha256 monterey:       "3501eece797a7bf06d3f127af8bcca954feac03c6fbddf0ad3a400807e56a258"
    sha256 big_sur:        "1f06e4ef4126d1c5cbb173d137d0fd9aa94034d06660b727e3309ad32d03deec"
    sha256 catalina:       "fc93b0be977009592fe1d1865ef1fec392c3f9d55b7e019a81fc7049995646ad"
    sha256 x86_64_linux:   "7627839147c68b2d49bf93842d60a8450fc82c9dac2934d38057eb3972b0f9cd"
  end

  depends_on "python@3.11"

  def install
    ENV["PYTHONINTERPRETER"] = which("python3.11")

    system "./configure", *std_configure_args
    system "make", "install"
  end
end
