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
    rebuild 3
    sha256 arm64_sequoia: "076d8ccde7798b91dd5d4180fc2d2debb7ef02e2db89cd365c6deebf6bc6efdf"
    sha256 arm64_sonoma:  "025053b284193b9d1c95198481f1590ff9215c899c37ef815af7112adf48be5d"
    sha256 arm64_ventura: "0d93bf91fbfa2c9b28872305a2fffdedb7ea4a92c9e0322804f4ec876e77f65c"
    sha256 sonoma:        "a06284e555f1de8ca3efe295422941c5707a6584ee0290db9c81bf65b73f16ed"
    sha256 ventura:       "7f29c2242dee1509abeef79da62ae9a5f34b74185042157895ef13184aa9c7c4"
    sha256 arm64_linux:   "7608787263a84503149fc6dffa46ba57ddd1a2b72856d40035b3eab5611aa507"
    sha256 x86_64_linux:  "d8f26d192338a7f45ef9a376c983cc97d873249106c78807cacd7964c7007b8e"
  end

  depends_on "python@3.13"

  def install
    ENV["PYTHONINTERPRETER"] = which("python3.13")

    system "./configure", *std_configure_args
    system "make", "install"
  end
end
