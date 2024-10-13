class GnuWhich < Formula
  desc "GNU implementation of which utility"
  # Previous homepage is dead. Have linked to the GNU Projects page for now.
  homepage "https://savannah.gnu.org/projects/which/"
  url "https://ftp.gnu.org/gnu/which/which-2.21.tar.gz"
  mirror "https://ftpmirror.gnu.org/which/which-2.21.tar.gz"
  sha256 "f4a245b94124b377d8b49646bf421f9155d36aa7614b6ebf83705d3ffc76eaad"
  license "GPL-3.0-or-later"

  bottle do
    rebuild 4
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "1802def6291edf6fde37b1926cfc80cc41e1d95be8bc867d04d34cc21835133b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6a984a5dacd2cc1fb1a408ef568cdd3219cfaea93e53de7cef4c263c832a6478"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "207bd913337ee0484767f38a161066d47e67b2d4328eed79b1652d2c52035d7e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "71f3da67b74f1d75cfdd05325b9ccc0d123d774291f11e1fa3395937ad04ba29"
    sha256 cellar: :any_skip_relocation, sonoma:         "f33ad5ef24c070a28b7422c0397af0e9efdadf679fd60f0615656ae11f619a7c"
    sha256 cellar: :any_skip_relocation, ventura:        "6e0afad40c63dc51ba4891d0580c714dafbee0f6ae5a5fd12e5cbaad20f43fcf"
    sha256 cellar: :any_skip_relocation, monterey:       "648d1369e3bee92727dc16bc5d3c97b754252d822452acb446183d8efea0f311"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "945684139954c72ae7c7442e5e4974fadeca1015275c35a166f7cab78d806cf2"
  end

  def install
    args = %W[
      --prefix=#{prefix}
      --disable-dependency-tracking
    ]

    args << "--program-prefix=g" if OS.mac?
    system "./configure", *args
    system "make", "install"

    if OS.mac?
      (libexec/"gnubin").install_symlink bin/"gwhich" => "which"
      (libexec/"gnuman/man1").install_symlink man1/"gwhich.1" => "which.1"
    end

    (libexec/"gnubin").install_symlink "../gnuman" => "man"
  end

  def caveats
    on_macos do
      <<~EOS
        GNU "which" has been installed as "gwhich".
        If you need to use it as "which", you can add a "gnubin" directory
        to your PATH from your bashrc like:

            PATH="#{opt_libexec}/gnubin:$PATH"
      EOS
    end
  end

  test do
    if OS.mac?
      system bin/"gwhich", "gcc"
      system opt_libexec/"gnubin/which", "gcc"
    else
      system bin/"which", "gcc"
    end
  end
end
