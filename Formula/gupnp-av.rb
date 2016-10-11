class GupnpAv < Formula
  desc "Library to help implement UPnP A/V profiles"
  homepage "https://wiki.gnome.org/GUPnP/"
  url "https://download.gnome.org/sources/gupnp-av/0.12/gupnp-av-0.12.9.tar.xz"
  sha256 "62c56449256a1a97b66c8ee59aa6455b90a7921285745ef3b79566218e85d447"

  bottle do
    sha256 "9070b9eadf5c90f701a71b21405ae906c1c0dacded13f71b0fdc9260e265d85e" => :sierra
    sha256 "6383fae084fbe704b8c483882dd367acb61671b68fda7fe311f2828c21676dcd" => :el_capitan
    sha256 "d9109b7adf543b11fe039b023833336971beb555270c9078838e053db5e5877f" => :yosemite
  end

  depends_on "pkg-config" => :build
  depends_on "intltool" => :build
  depends_on "gettext"
  depends_on "gupnp"

  def install
    ENV["ax_cv_check_cflags__Wl___no_as_needed"] = "no"

    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
