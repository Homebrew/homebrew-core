class GnuTime < Formula
  desc "GNU implementation of time utility"
  homepage "https://www.gnu.org/software/time/"
  url "https://ftp.gnu.org/gnu/time/time-1.9.tar.gz"
  mirror "https://ftpmirror.gnu.org/time/time-1.9.tar.gz"
  sha256 "fbacf0c81e62429df3e33bda4cee38756604f18e01d977338e23306a3e3b521e"
  license "GPL-3.0-or-later"

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ff4691a2d76432eb0222284ccbeda79b3375cefdb1c606ba74ea3e8e06ac25f5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3930463651363f08ca7a90ec25deafd85c57f7a71be8ee236f7e15f20de7ff22"
    sha256 cellar: :any_skip_relocation, monterey:       "e7b649410f591aa0d0068ae267e7357db99c86c73fd5e992db0f5512614a07a6"
    sha256 cellar: :any_skip_relocation, big_sur:        "f4fc9d2c49b65130d04a476d4cd887b1e1033a7870df9805be28aba09be901f0"
    sha256 cellar: :any_skip_relocation, catalina:       "9a1d1160f85f46b3022dc4d978dfafe6b3a02fc97446bc51f8b1ae4580b7c69a"
    sha256 cellar: :any_skip_relocation, mojave:         "dc007b95e2f9fb0df3380da55d3c9337529b1a4a3cd762972eb88512f567ea1c"
    sha256 cellar: :any_skip_relocation, high_sierra:    "ad5d776c38e43f16fad8976770eeaa18e40562c166fa65fdaa12af61981c7b90"
    sha256 cellar: :any_skip_relocation, sierra:         "d51ef948a5a87281175fef771cb28469cbdb3085e3c51ad325d780ff921cc013"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c9c5ae5e7ac2f00cf8655ce4b6095e4706bcc36300d36a1c7121ab03d010ea5f"
  end

  uses_from_macos "ruby" => :test

  def install
    args = %W[
      --prefix=#{prefix}
      --info=#{info}
    ]

    args << "--program-prefix=g" if OS.mac?
    system "./configure", *args
    system "make", "install"

    (libexec/"gnubin").install_symlink bin/"gtime" => "time" if OS.mac?
  end

  def caveats
    on_macos do
      <<~EOS
        GNU "time" has been installed as "gtime".
        If you need to use it as "time", you can add a "gnubin" directory
        to your PATH from your bashrc like:

            PATH="#{opt_libexec}/gnubin:$PATH"
      EOS
    end
  end

  test do
    on_macos do
      system bin/"gtime", "ruby", "--version"
      system opt_libexec/"gnubin/time", "ruby", "--version"
    end

    on_linux do
      system bin/"time", "ruby", "--version"
    end
  end
end
