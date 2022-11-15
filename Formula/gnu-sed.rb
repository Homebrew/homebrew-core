class GnuSed < Formula
  desc "GNU implementation of the famous stream editor"
  homepage "https://www.gnu.org/software/sed/"
  url "https://ftp.gnu.org/gnu/sed/sed-4.9.tar.xz"
  mirror "https://ftpmirror.gnu.org/sed/sed-4.9.tar.xz"
  sha256 "6e226b732e1cd739464ad6862bd1a1aba42d7982922da7a53519631d24975181"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5abaf39c16d02125db97d14cd36a96cf1a20a87821199cb38a55134fd4e0aaef"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "20ae3f853a32e7f7f0f340e8c751ab7350888a655bfe7c5c20e5746c61a24fd7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d7c89842a90d03dbb497bc1ded17b7d732fe20eaf69613fd4abb48820ab80895"
    sha256 cellar: :any_skip_relocation, ventura:        "a1ac59a9a6fa20c6c904e047df3ee4d0b4e57c0a5df3821b17b8cd82bcc67b5a"
    sha256 cellar: :any_skip_relocation, monterey:       "f5e2460ad86516b2517f1e77d672a4fd6ad30b158c470cccbb3b6464f228674d"
    sha256 cellar: :any_skip_relocation, big_sur:        "c1c63d995d132a82fadc80b470eecfe816cb86c8cd716f01de5f003bc1199fcc"
    sha256 cellar: :any_skip_relocation, catalina:       "fb5ee7317d987d9ac7f2ee357736a9bc594c88b5fbbca4f6a65046f1c2898c44"
    sha256                               x86_64_linux:   "8abd5b48de6b706c1ce7c2f7b8775420f63078ba294bd5ad801e458776228bbc"
  end

  conflicts_with "ssed", because: "both install share/info/sed.info"

  def install
    args = %W[
      --prefix=#{prefix}
      --disable-dependency-tracking
    ]

    args << if OS.mac?
      "--program-prefix=g"
    else
      "--without-selinux"
    end
    system "./configure", *args
    system "make", "install"

    if OS.mac?
      (libexec/"gnubin").install_symlink bin/"gsed" =>"sed"
      (libexec/"gnuman/man1").install_symlink man1/"gsed.1" => "sed.1"
    end

    libexec.install_symlink "gnuman" => "man"
  end

  def caveats
    on_macos do
      <<~EOS
        GNU "sed" has been installed as "gsed".
        If you need to use it as "sed", you can add a "gnubin" directory
        to your PATH from your bashrc like:

            PATH="#{opt_libexec}/gnubin:$PATH"
      EOS
    end
  end

  test do
    (testpath/"test.txt").write "Hello world!"
    if OS.mac?
      system "#{bin}/gsed", "-i", "s/world/World/g", "test.txt"
      assert_match "Hello World!", File.read("test.txt")

      system "#{opt_libexec}/gnubin/sed", "-i", "s/world/World/g", "test.txt"
    else
      system "#{bin}/sed", "-i", "s/world/World/g", "test.txt"
    end
    assert_match "Hello World!", File.read("test.txt")
  end
end
