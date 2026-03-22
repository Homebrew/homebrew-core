class Nano < Formula
  desc "Free (GNU) replacement for the Pico text editor"
  homepage "https://www.nano-editor.org/"
  url "https://www.nano-editor.org/dist/v8/nano-8.7.1.tar.xz"
  sha256 "76f0dcb248f2e2f1251d4ecd20fd30fb400a360a3a37c6c340e0a52c2d1cdedf"
  license "GPL-3.0-or-later"

  livecheck do
    url "https://www.nano-editor.org/download.php"
    regex(/href=.*?nano[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:   "035b76b35f03f3e8da0187d0a3858ba77989858b31557f1620239fe81377cc2f"
    sha256 arm64_sequoia: "95fa0e3f88f5fd72c59c707c9482731a4903e4bfebb9db6ec01a96609d82ec34"
    sha256 arm64_sonoma:  "509b102061e59a4b04bfdbfd01bf29b59796a03a7eef5e8d29cee766f7532c77"
    sha256 sonoma:        "3a3bf0c2345b449c94843d0413227b3445df31b065ee8558df467a4ae627dbaf"
    sha256 arm64_linux:   "cea02dc07e9b0311fea704cd84e75c32cfd103076caf80cb2b63b3771b68cd3c"
    sha256 x86_64_linux:  "a0fb3781c74d1a8672c5465b490b0062deba3043421dd344f98d1d9b5175c01c"
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
