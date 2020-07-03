class Cdargs < Formula
  desc "Directory bookmarking system - Enhanced cd utilities"
  homepage "https://github.com/cbxbiker61/cdargs"
  url "https://github.com/cbxbiker61/cdargs/archive/2.0.tar.gz"
  sha256 "d6c7b0a3636338916f6d8efa069b3b9521330b3da79d9d625ab7a9a1091162a8"
  head "https://github.com/cbxbiker61/cdargs.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "6be0f8aaab5aaed898d0e575422dad6b89ac4bca96969627d723f0f4ac040cfd" => :catalina
    sha256 "3129dc20e3cf7e5aa4124ea6640ed80674e9111a85f0766d6ffa6b13475cc019" => :mojave
    sha256 "7eb3efb581cace2e18f9897b7db17bfda9bfce082ea07912c92f5be34bd6d38e" => :high_sierra
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build

  # fixes zsh usage using the patch provided at the cdargs homepage
  # (See https://www.skamphausen.de/cgi-bin/ska/CDargs)
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/85fa66a9/cdargs/1.35.patch"
    sha256 "adb4e73f6c5104432928cd7474a83901fe0f545f1910b51e4e81d67ecef80a96"
  end

  def install
    mkdir "build" do
      system "meson", *std_meson_args, ".."
      system "ninja", "-v"
      system "ninja", "install", "-v"
    end

    rm Dir["contrib/Makefile*"]
    prefix.install "contrib"
    bash_completion.install_symlink "#{prefix}/contrib/cdargs-bash.sh"
  end

  def caveats
    <<~EOS
      Support files for bash, tcsh, and emacs have been installed to:
        #{prefix}/contrib
    EOS
  end

  test do
    system "#{bin}/cdargs", "--version"
  end
end
