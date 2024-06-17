class GnuUnits < Formula
  desc "GNU unit conversion tool"
  homepage "https://www.gnu.org/software/units/"
  url "https://ftp.gnu.org/gnu/units/units-2.23.tar.gz"
  mirror "https://ftpmirror.gnu.org/units/units-2.23.tar.gz"
  sha256 "d957b451245925c9e614c4513397449630eaf92bd62b8495ba09bbe351a17370"
  license "GPL-3.0-or-later"

  bottle do
    sha256 arm64_sonoma:   "8be10faad6f9a7391148fe0cd5748b28cd3b2194ef0b4f4a14c1ce78f4466b2f"
    sha256 arm64_ventura:  "90a4e4efe9e2cc803aad78fa7b5d5e69dc0651fb22ec380e944ef854e932ef26"
    sha256 arm64_monterey: "d8b640be8f30166129f8b91105c9edf75a1c9b5df05a8094d1266d6c7bbf71fc"
    sha256 sonoma:         "1c878e0d2ce4967ffe7a47d973e347e628a1a18590b3b3a4ec6f25e6878f818b"
    sha256 ventura:        "661431292b871a07d71e0a96a7ac8c034126f88e5137b37caa21eab6e4f96c15"
    sha256 monterey:       "376b628a76336b62a49e0e630c4a4573a1e3c4b42c7325209f5e85af36888d27"
    sha256 x86_64_linux:   "62ebf75d2507b08f9979204e0ce049f953cd4b498db42080bebce78247abbfc5"
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
    libexec.install_symlink "gnuman" => "man"
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
