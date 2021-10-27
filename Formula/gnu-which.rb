class GnuWhich < Formula
  desc "GNU implementation of which utility"
  # Previous homepage is dead. Have linked to the GNU Projects page for now.
  homepage "https://savannah.gnu.org/projects/which/"
  url "https://ftp.gnu.org/gnu/which/which-2.21.tar.gz"
  mirror "https://ftpmirror.gnu.org/which/which-2.21.tar.gz"
  sha256 "f4a245b94124b377d8b49646bf421f9155d36aa7614b6ebf83705d3ffc76eaad"
  license "GPL-3.0-or-later"

  bottle do
    rebuild 3
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8343d2e916151642b540143f2b3f8a79af4a6e22df55e01b846bad2d0e509074"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "873e8ac50fdc7b40699f7ebcf29c73c768d2db8d958f1fdb2d4be13c0b670c3a"
    sha256 cellar: :any_skip_relocation, monterey:       "21e5e71e2a9aadc88636bdb7e76dc5aef17e5ca31b99e02553bc61263e2c36e8"
    sha256 cellar: :any_skip_relocation, big_sur:        "eeb493d3cc6252da45b29cf1d2a1d6daca630a6cd467ae690c3979673ea9a589"
    sha256 cellar: :any_skip_relocation, catalina:       "f9e6512591096a9f53067ea4a0b5b9f8516515b49fd5bdabfc6e31c1c0c876f2"
    sha256 cellar: :any_skip_relocation, mojave:         "170008e80a4cc5f1e45b3445f9fb6f099d7700aa6dd825602f6d32316c27735b"
    sha256 cellar: :any_skip_relocation, high_sierra:    "66446416b0dc367076ab38cfc9775d8c201fc571b1a2cd2fc0197daa6b83882a"
    sha256 cellar: :any_skip_relocation, sierra:         "68ea3522ec318c9b25d711ce4405b4cd6a41edca20b7df008adc499ab794c4fa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cf191a85d1f5684e84909ccf5d5df3ec3b9ffd7facc629bc2664f99078bf414e"
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

    libexec.install_symlink "gnuman" => "man"
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
    on_macos do
      system "#{bin}/gwhich", "gcc"
      system "#{opt_libexec}/gnubin/which", "gcc"
    end
    on_linux do
      system "#{bin}/which", "gcc"
    end
  end
end
