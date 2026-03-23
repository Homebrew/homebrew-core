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
    rebuild 4
    sha256 arm64_tahoe:   "3beb6a1ce60e6650160ff71cf64d77920834134018551376cad01365291f6be2"
    sha256 arm64_sequoia: "83cd968856bbc4f8933c1372b74975169265c4162f1e9b40460037773f1be37b"
    sha256 arm64_sonoma:  "9d33fd677c79d6066cf6734adb4526becfa36b5cc57f34769ab03de88178833d"
    sha256 sonoma:        "692ef1ca0ffbe0e2295d789686a23accefe9cdd29a475118be97c06bdd8697bc"
    sha256 arm64_linux:   "57de95e3030b4885a69a541fddeea9caf1b08eb25ae58549e482ccc245c565e7"
    sha256 x86_64_linux:  "48db655b0b901abb3a6caaedbc6609a3a36fea0601676f23bf3894ddb800626c"
  end

  depends_on "python@3.14"

  def install
    ENV["PYTHONINTERPRETER"] = which("python3.14")

    system "./configure", *std_configure_args
    system "make", "install"
  end
end
