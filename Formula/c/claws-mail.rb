class ClawsMail < Formula
  desc "User-friendly, lightweight, and fast email client"
  homepage "https://www.claws-mail.org/"
  url "https://www.claws-mail.org/releases/claws-mail-4.2.0.tar.gz"
  sha256 "446c89f27c2205277f08e776b53d9d151be013211d91e7d9da006bc95c051c60"
  license "GPL-3.0-or-later"

  livecheck do
    url "https://www.claws-mail.org/releases.php"
    regex(/href=.*?claws-mail[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sonoma:   "dc82ecd9048716b1887d8d9f26d232f1f552a19051aac50934e4f21174897b1f"
    sha256 arm64_ventura:  "70b19b515fbe5601dace57bab913a27ff1a0fdd5b2822447a943a0be04eb6eb1"
    sha256 arm64_monterey: "b0679bfc922e144669028b3a1b4ef30c73252d4fdcfeea3a09b5906491826cb9"
    sha256 sonoma:         "fab6a7990fe0bbddd628c25bd0876fbeb359c87faf3142c44d6ff14f60eff598"
    sha256 ventura:        "8dc1cf763265e2a64f9a4a2eac8128a00c0b101a14717e40b2f751afa30bbd3c"
    sha256 monterey:       "c0fd26b3606755c94be9e5e859b3100e362d78b786c92cec17393fd4c2091ee3"
  end

  depends_on "pkg-config" => :build
  depends_on "cairo"
  depends_on "glib"
  depends_on "gnutls"
  depends_on "gtk+3"
  depends_on "libetpan"
  depends_on "nettle"

  # Backport fix for building on non-X11 systems.
  patch do
    url "https://git.claws-mail.org/?p=claws.git;a=patch;h=dd4c4e5152235f9f4f319cc9fdad9227ebf688c9"
    sha256 "883c30d0aa0a6450051c9452475ecc0e106297d0765facc07cacf96cde4a4556"
  end

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
