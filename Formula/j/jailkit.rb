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
    rebuild 2
    sha256 arm64_sonoma:   "b6c0c3c1107be5a4bdc64133a96ff0825bee4f0e2e5137c8a936250b2c36c687"
    sha256 arm64_ventura:  "5e555a333e8e410170f19a4a5d6cfeb18f35b93cafeb4fa36558c67ccccc3f04"
    sha256 arm64_monterey: "9899513595b06db714f7e16c5020fc6af232e145134d950c62d755e290426489"
    sha256 sonoma:         "392443c175a16f451cf4183f0d1443a87a7754f400e799e5c2851532264300a0"
    sha256 ventura:        "d820a942947750a13ab6e2a2f47dedb3b2d11a512fabdad32e80dfe4b4e1a0dc"
    sha256 monterey:       "8ca03d7e266f8d2a7f1e73431e12935b3a37fa81e07c749cbfe15fbf78ce8153"
    sha256 x86_64_linux:   "449133e50ae1f47700b40ccfffdc78d7aaf390a393bc57178b39e1458ab0b397"
  end

  depends_on "python@3.12"

  def install
    ENV["PYTHONINTERPRETER"] = which("python3.12")

    system "./configure", *std_configure_args
    system "make", "install"
  end
end
