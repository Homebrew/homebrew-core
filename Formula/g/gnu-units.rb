class GnuUnits < Formula
  desc "GNU unit conversion tool"
  homepage "https://www.gnu.org/software/units/"
  url "https://ftpmirror.gnu.org/gnu/units/units-2.25.tar.gz"
  mirror "https://ftp.gnu.org/gnu/units/units-2.25.tar.gz"
  sha256 "36edf43ac00b4d6304baea91387e65ab05118bf65c921f73d3b08828e5a6ec0b"
  license "GPL-3.0-or-later"

  bottle do
    sha256 arm64_tahoe:   "d3eef8599491e75d5e68964a46d4f6c4e2f754eccac0509d3e122608867f429f"
    sha256 arm64_sequoia: "5c87b0358b4ecb34e50f4e0655141e4cc5d7189b68168622a8582f5c3de210e2"
    sha256 arm64_sonoma:  "d79aa5d6678f4db8196e225071b46a89cf510fe02e938057cb302b05fb5b8aae"
    sha256 sonoma:        "d9ade4721a6ea33d1285e3e05be2b346e1a14cdac148126a88a69387af3dc3f3"
    sha256 arm64_linux:   "90c4e0c370898ee10ab445393cdbd93ca82f0c884fed76c6dfe7ab3e72e3a5cb"
    sha256 x86_64_linux:  "3a0d4ce28f8c4d866c2b23180dcbe78c9b1ce34b3ef41fe00c0dd4db10116e56"
  end

  depends_on "readline"

  def install
    args = %W[
      --prefix=#{prefix}
      --with-installed-readline
    ]

    args << "--program-prefix=g" if OS.mac?
    system "./configure", *args
    system "make", "install"

    if OS.mac?
      (libexec/"gnubin").install_symlink bin/"gunits" => "units"
      (libexec/"gnubin").install_symlink bin/"gunits_cur" => "units_cur"
      (libexec/"gnuman/man1").install_symlink man1/"gunits.1" => "units.1"
    end
    (libexec/"gnubin").install_symlink "../gnuman" => "man"
  end

  def caveats
    on_macos do
      <<~EOS
        All commands have been installed with the prefix "g".
        If you need to use these commands with their normal names, you
        can add a "gnubin" directory to your PATH from your bashrc like:
          PATH="#{opt_libexec}/gnubin:$PATH"
      EOS
    end
  end

  test do
    if OS.mac?
      assert_equal "* 18288", shell_output("#{bin}/gunits '600 feet' 'cm' -1").strip
      assert_equal "* 18288", shell_output("#{opt_libexec}/gnubin/units '600 feet' 'cm' -1").strip
    else
      assert_equal "* 18288", shell_output("#{bin}/units '600 feet' 'cm' -1").strip
    end
  end
end
