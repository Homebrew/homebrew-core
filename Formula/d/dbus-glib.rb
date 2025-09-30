class DbusGlib < Formula
  desc "GLib bindings for the D-Bus message bus system"
  homepage "https://wiki.freedesktop.org/www/Software/DBusBindings/"
  url "https://dbus.freedesktop.org/releases/dbus-glib/dbus-glib-0.114.tar.gz"
  sha256 "c09c5c085b2a0e391b8ee7d783a1d63fe444e96717cc1814d61b5e8fc2827a7c"
  license all_of: [
    "GPL-2.0-or-later", # dbus/dbus-bash-completion-helper.c
    any_of: ["AFL-2.1", "GPL-2.0-or-later"],
  ]

  livecheck do
    url "https://dbus.freedesktop.org/releases/dbus-glib/"
    regex(/href=.*?dbus-glib[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "401e43f50e9b03988ef5f057f5c4bfc097e593ae90403e9a5536a004bcefb7be"
    sha256 cellar: :any,                 arm64_sequoia: "c6b0c2054217bf77789f11c4cf02732d2397576cdb25ed828845bc8c6808dbd7"
    sha256 cellar: :any,                 arm64_sonoma:  "2fccf8368eafc625c759030d1c3528bd42e60e5212f1d9c8255875280c20c799"
    sha256 cellar: :any,                 arm64_ventura: "d257be9b74a17d6e35a8b8c5e89491ff2fb9f83a828f442e787110c27a9c5cd2"
    sha256 cellar: :any,                 sonoma:        "4c988a24f589781b5bb28327a21c4747b63f791f322373697a5ce5638b618cc2"
    sha256 cellar: :any,                 ventura:       "92ba5dadd11f3b7371bdc9d508ca8223f565649e61eb22e678d1de9faaa272de"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8249f4716373f900407265373ce487766766565b614a81875194881fc6a01117"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dc8cacd16db1b5c793b1d76dc356a774f6bdac23866e441276e9d28faaf2125a"
  end

  depends_on "pkgconf" => :build
  depends_on "dbus"
  depends_on "glib"

  uses_from_macos "expat"

  on_macos do
    depends_on "gettext"
  end

  def install
    system "./configure", "--disable-silent-rules", *std_configure_args
    system "make", "install"
  end

  test do
    system bin/"dbus-binding-tool", "--help"
  end
end
