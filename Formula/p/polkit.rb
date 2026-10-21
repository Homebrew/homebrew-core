class Polkit < Formula
  desc "Toolkit for defining and handling authorizations"
  homepage "https://github.com/polkit-org/polkit"
  url "https://github.com/polkit-org/polkit/archive/refs/tags/128.tar.gz"
  sha256 "6edb06bf1448e49e428f9597a97af6a05d62146dd0b58f86eeaebcee3f5ecfaa"
  license "LGPL-2.0-or-later"

  bottle do
    sha256 arm64_golden_gate: "daf513f1270b19090bc8c6060877b860b4424af4bceaaa98d2f6abf6505616b0"
    sha256 arm64_tahoe:       "9ead3bd790d8dd4dff010e83f9d039d7ade180c86343b685b2549cc00756aba3"
    sha256 arm64_sequoia:     "ee6c7cfb714f6b61a9cad87ef6088874fad6af4f957124131073442459d7dc49"
    sha256 arm64_linux:       "50845efd3aca93baee5c895a767ec5394f8d2b444d99ccbc9e2da65c71f2dc25"
    sha256 x86_64_linux:      "b4d1ab1ba5df1395b655b528358ec652c2995b0eace62f4e9b7c98bd01957aea"
  end

  depends_on "gettext" => :build
  depends_on "gobject-introspection" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => [:build, :test]
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
    # Avoid installing into the systemd keg (paths taken from systemd.pc) or /usr/lib
    inreplace "meson.build" do |s|
      s.gsub!("systemd_dep.get_variable(pkgconfig : 'sysusers_dir')", "'#{etc}/sysusers.d'")
      s.gsub!("systemd_dep.get_variable(pkgconfig : 'tmpfiles_dir')", "'#{etc}/tmpfiles.d'")
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
    (testpath/"test.c").write <<~C
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
    C

    flags = shell_output("pkgconf --cflags --libs polkit-gobject-1").strip.split
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end
