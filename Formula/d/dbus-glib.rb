class DbusGlib < Formula
  desc "GLib bindings for the D-Bus message bus system"
  homepage "https://wiki.freedesktop.org/www/Software/DBusBindings/"
  url "https://dbus.freedesktop.org/releases/dbus-glib/dbus-glib-0.116.tar.gz"
  sha256 "e3f3d4487e2883800770ed5899ed111bdc4ba7056af34a255c4c46ad8a2486f3"
  license all_of: [
    "GPL-2.0-or-later", # dbus/dbus-bash-completion-helper.c
    any_of: ["AFL-2.1", "GPL-2.0-or-later"],
  ]

  livecheck do
    url "https://dbus.freedesktop.org/releases/dbus-glib/"
    regex(/href=.*?dbus-glib[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "dac4154763b11e67006b2dd05d63c360c43197193a1c7dacdfefd8aa785804a4"
    sha256 cellar: :any, arm64_tahoe:       "035a6a708cbd2b19bec2ed2f0cfac7562302719a36c5201de4e806b30791a8e8"
    sha256 cellar: :any, arm64_sequoia:     "7f8b41675880cd476ded5af2f3b4f28906762b0a682905b14b9936b21a489fdd"
    sha256 cellar: :any, arm64_linux:       "6e917b08d6bff3dcd873dd86b2ae686c0b04ced3d2d42271db062c7a57f7f05c"
    sha256 cellar: :any, x86_64_linux:      "2bb4b5dc4ccb63554db4443b11376b02aa644a15664ee98b60ca2d6a1eb5b0b4"
  end

  depends_on "pkgconf" => :build
  depends_on "dbus"
  depends_on "glib"

  uses_from_macos "expat"

  on_macos do
    depends_on "gettext"
  end

  deny_network_access!

  def install
    system "./configure", "--disable-silent-rules", *std_configure_args
    system "make", "install"
  end

  test do
    system bin/"dbus-binding-tool", "--help"
  end
end
