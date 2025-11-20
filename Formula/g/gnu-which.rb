class GnuWhich < Formula
  desc "GNU implementation of which utility"
  # Previous homepage is dead. Have linked to the GNU Projects page for now.
  homepage "https://savannah.gnu.org/projects/which/"
  url "https://ftpmirror.gnu.org/gnu/which/which-2.23.tar.gz"
  mirror "https://ftp.gnu.org/gnu/which/which-2.23.tar.gz"
  sha256 "a2c558226fc4d9e4ce331bd2fd3c3f17f955115d2c00e447618a4ef9978a2a73"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e90a6ecbd9fb9b0134ff618f44d6993edd632d8a7529d3ec51b03fb708722e94"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "91778a7be9cd94c5de2d8040fb7405541497dd97df1daa1cc562b5a7194e2688"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3b59742c30bca0d70fd803414b20aba6af45ff3fe59941bcb68485074b7ca28b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "17a52b327ea1d2a30313c98f73105943f22c6307aa29ced85558440c679fbcc6"
    sha256 cellar: :any_skip_relocation, sonoma:        "1a0d51cf354ef62e06eaeaf5a6fe4a76f655ba084025382dbf6405a35feacc42"
    sha256 cellar: :any_skip_relocation, ventura:       "c6ec0fe0903e5d08057045a2d4e99a1a6b934ae0df8c530fb06571cdb98084ed"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "665706e5c4562d4a250889303098d4773153ade7d14609fdcf317966cc50080c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "81baea2942f92fa1c2cfa15adc71aa2d9e845c48f4339586cc78985327b53666"
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
