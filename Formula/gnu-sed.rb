class GnuSed < Formula
  desc "GNU implementation of the famous stream editor"
  homepage "https://www.gnu.org/software/sed/"
  url "https://ftp.gnu.org/gnu/sed/sed-4.8.tar.xz"
  mirror "https://ftpmirror.gnu.org/sed/sed-4.8.tar.xz"
  sha256 "f79b0cfea71b37a8eeec8490db6c5f7ae7719c35587f21edb0617f370eeff633"
  license "GPL-3.0-or-later"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "3846b361699dd0260a616085b2a1678c874a2fcce8ce70e704a018dce3b4a882" => :big_sur
    sha256 "72bc2b8cf7c7e18d106d79c7db382f7160408aafa8fb765b084cbe965e92db9b" => :arm64_big_sur
    sha256 "726be75d6d7155820b408a10e5c1a5ba1406374a7fc167af62524a4f4bbbc099" => :catalina
    sha256 "093f16752e7dfb115c055f20aed090108b94edd47c40f5e50878d961359251b2" => :mojave
    sha256 "865abe618c67037a4a419a05e0df2c6814fb3abdd6f631ea546aeba0aaf8eb78" => :high_sierra
  end

  conflicts_with "ssed", because: "both install share/info/sed.info"

  def install
    args = %W[
      --prefix=#{prefix}
      --disable-dependency-tracking
    ]

    on_macos do
      args << "--program-prefix=g"
    end
    on_linux do
      args << "--without-selinux"
    end
    system "./configure", *args
    system "make", "install"

    on_macos do
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
    on_macos do
      system "#{bin}/gsed", "-i", "s/world/World/g", "test.txt"
      assert_match /Hello World!/, File.read("test.txt")

      system "#{opt_libexec}/gnubin/sed", "-i", "s/world/World/g", "test.txt"
      assert_match /Hello World!/, File.read("test.txt")
    end
    on_linux do
      system "#{bin}/sed", "-i", "s/world/World/g", "test.txt"
      assert_match /Hello World!/, File.read("test.txt")
    end
  end
end
