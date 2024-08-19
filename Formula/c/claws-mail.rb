class ClawsMail < Formula
  desc "User-friendly, lightweight, and fast email client"
  homepage "https://www.claws-mail.org/"
  url "https://www.claws-mail.org/releases/claws-mail-4.3.0.tar.gz"
  sha256 "24a4d024c36f98add0e0b935cfa03cc6df01bc1b3f479a7a9d6df57705b04b2f"
  license "GPL-3.0-or-later"

  livecheck do
    url "https://www.claws-mail.org/releases.php"
    regex(/href=.*?claws-mail[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sonoma:   "260cc6ed26555448097f742c63e73bcedd1c29e6255593c04ac9c7534c82fbd6"
    sha256 arm64_ventura:  "01403c8a41e6e0c6712ecdc32353139671b4c784c916de9e5bbf8ee3f2b499d6"
    sha256 arm64_monterey: "6f6056afe0b0dd10c3e9d37127f50a9498db8beb0a764cd78188fa030dc59bd7"
    sha256 sonoma:         "1819b7c665b74c617018dcadd6b479d19db69ed4678683eb866fef502b0b1899"
    sha256 ventura:        "e916c03bc2f8b9a17237783044ae9c13fb039bbe06a0cb10b00e365c70be3472"
    sha256 monterey:       "9a22338fd482708205faeecd789eddd4b8d692f0dea74aad135d595e5ab3b86a"
    sha256 x86_64_linux:   "d853654004fa0fbb3f57ba98d2ec1d715223027ff6e55452a54c4d369940a060"
  end

  depends_on "pkg-config" => :build
  depends_on "cairo"
  depends_on "glib"
  depends_on "gnutls"
  depends_on "gtk+3"
  depends_on "libetpan"
  depends_on "nettle"

  def install
    ENV.append "LDFLAGS", "-Wl,-framework -Wl,Security" if OS.mac?
    system "./configure", *std_configure_args,
                          "--disable-silent-rules",
                          "--disable-archive-plugin",
                          "--disable-dillo-plugin",
                          "--disable-notification-plugin"
    system "make", "install"
  end

  test do
    assert_equal ".claws-mail", shell_output("#{bin}/claws-mail --config-dir").strip
  end
end
