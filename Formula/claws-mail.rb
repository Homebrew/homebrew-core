class ClawsMail < Formula
  desc "User-friendly, lightweight, and fast email client"
  homepage "https://www.claws-mail.org/"
  url "https://www.claws-mail.org/releases/claws-mail-3.17.7.tar.gz"
  sha256 "47e634fcea55f08bd401849c7a3827f8a4a277fda15788961ff0aac5d59ecc38"
  license "GPL-3.0-or-later"

  bottle do
    sha256 "7777390cfea96a30277ebb79738341f0944bae3dcfd18a7befd2748ea4671356" => :catalina
    sha256 "6a7264ed191bcfdc7ae1b1c1020a09b3d9b224e61b45c876cc047db181a225cb" => :mojave
    sha256 "3d5c69c7654a22c8b51d3a7bf18224a40fade38281bb4c4fb4287221b3ca19ee" => :high_sierra
  end

  depends_on "pkg-config" => :build
  depends_on "cairo"
  depends_on "glib"
  depends_on "gnutls"
  depends_on "gtk+"
  depends_on "libetpan"
  depends_on "nettle"

  def install
    system "./configure", "--prefix=#{prefix}",
                          "LDFLAGS=-Wl,-framework -Wl,Security",
                          "--disable-archive-plugin",
                          "--disable-dillo-plugin",
                          "--disable-notification-plugin"
    system "make", "install"
  end

  test do
    assert_equal ".claws-mail", shell_output("#{bin}/claws-mail --config-dir").strip
  end
end
