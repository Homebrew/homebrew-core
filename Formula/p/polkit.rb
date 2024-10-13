class Polkit < Formula
  desc "Toolkit for defining and handling authorizations"
  homepage "https://github.com/polkit-org/polkit"
  url "https://github.com/polkit-org/polkit/archive/refs/tags/125.tar.gz"
  sha256 "ea5cd6e6e2afa6bad938ee770bf0c2cd9317910f37956faeba2869adcf3747d1"
  license "LGPL-2.0-or-later"

  bottle do
    rebuild 1
    sha256 arm64_sequoia: "65b4487221ade356f4abeb1cfea43fd90568ce50a3c1b0eb384398e681b0cda5"
    sha256 arm64_sonoma:  "ec68813f4943b61236f3cf1dbc44a4a9fe950580fe938c8ec2b63e44f81ccea6"
    sha256 arm64_ventura: "9b3b128ae692df21a9aa26abc2e1083150f87c0dab0fea63b0fafd82ce7c2ed1"
    sha256 sonoma:        "a153baa59aa9a6384a430640cdc462b7edd20b753954214f48d1a42c25d79adf"
    sha256 ventura:       "e6173addbdca3c556fc28b3d0f78c404c91a97443fb5445be97ce537a8963b9a"
    sha256 x86_64_linux:  "1683127bee952122bb0d13deac8f49d238280b619045b6cabf5f9d3e72d98ebb"
  end

  depends_on "gettext" => :build
  depends_on "gobject-introspection" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => [:build, :test]
  depends_on "duktape"
  depends_on "glib"
  uses_from_macos "expat"

  on_macos do
    depends_on "gettext"
  end

  on_linux do
    depends_on "linux-pam"
    depends_on "systemd"
  end

  def install
    inreplace "meson.build" do |s|
      s.gsub!("sysusers_dir = '/usr/lib/sysusers.d'", "sysusers_dir = '#{etc}/sysusers.d'")
      s.gsub!("tmpfiles_dir = '/usr/lib/tmpfiles.d'", "tmpfiles_dir = '#{etc}/tmpfiles.d'")
    end

    args = [
      "-Dsystemdsystemunitdir=#{lib}/systemd/system",
      "-Dpam_prefix=#{etc}/pam.d",
      "-Dpam_module_dir=#{lib}/pam",
    ]
    args << "-Dsession_tracking=ConsoleKit" if OS.mac?

    ENV.append_to_cflags "-Wno-implicit-function-declaration" if DevelopmentTools.clang_build_version >= 1403
    system "meson", "setup", "build", *args, *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <glib.h>
      #include <polkit/polkit.h>

      int main() {
        PolkitUnixGroup *group = POLKIT_UNIX_GROUP(polkit_unix_group_new(0));
        g_assert(group);

        gint group_gid = polkit_unix_group_get_gid(group);
        g_assert_cmpint(group_gid, ==, 0);

        g_object_unref(group);
        return 0;
      }
    EOS

    flags = shell_output("pkg-config --cflags --libs polkit-gobject-1").strip.split
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end
