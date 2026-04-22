class Nano < Formula
  desc "Free (GNU) replacement for the Pico text editor"
  homepage "https://www.nano-editor.org/"
  url "https://www.nano-editor.org/dist/v9/nano-9.0.tar.xz"
  sha256 "9f384374b496110a25b73ad5a5febb384783c6e3188b37063f677ac908013fde"
  license "GPL-3.0-or-later"

  livecheck do
    url "https://www.nano-editor.org/download.php"
    regex(/href=.*?nano[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:   "0a983eefbaf98e0b9d1fe9fec31c8e573777a080b86521c2d121a9a0e5831890"
    sha256 arm64_sequoia: "78489eb5b719a880ae4df40db133de2cbbc68f6eb3821b84612ee83b4f172a5f"
    sha256 arm64_sonoma:  "f3e7bf555bdbf2f76cb746dc35e6e7bf87bbaf0be01ce84cbadf8413674493da"
    sha256 sonoma:        "f85eabd5621465c91b3e370005d3363ab5738b174b58ebb5123fda6ddc293ab8"
    sha256 arm64_linux:   "2302672047e0fb5c5ab0ff0cdde437ffff60f030a781e848915fce42ebc16638"
    sha256 x86_64_linux:  "a3f04be362cea9da1cecebc05035784a8c68cd9224951bdfb6da5953bf15b102"
  end

  depends_on "pkgconf" => :build
  depends_on "ncurses"

  on_macos do
    depends_on "gettext"
  end

  on_linux do
    depends_on "libmagic"
  end

  def install
    system "./configure", "--enable-color",
                          "--enable-extra",
                          "--enable-multibuffer",
                          "--enable-nanorc",
                          "--enable-utf8",
                          "--sysconfdir=#{etc}",
                          *std_configure_args
    system "make", "install"
    doc.install "doc/sample.nanorc"
  end

  test do
    system bin/"nano", "--version"

    # Skip test on Intel macOS due to CI failures
    return if OS.mac? && Hardware::CPU.intel?

    PTY.spawn(bin/"nano", "test.txt") do |r, w, _pid|
      sleep 1
      w.write "test data"
      sleep 1
      w.write "\u0018" # Ctrl+X
      sleep 1
      w.write "y"      # Confirm save
      sleep 1
      w.write "\r"     # Enter to confirm filename
      sleep 1
      OS.mac? && r.read
    end

    assert_match "test data", (testpath/"test.txt").read
  end
end
