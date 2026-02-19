class Polkit < Formula
  desc "Toolkit for defining and handling authorizations"
  homepage "https://github.com/polkit-org/polkit"
  url "https://github.com/polkit-org/polkit/archive/refs/tags/127.tar.gz"
  sha256 "9b7bc16f086479dcc626c575976568ba4a85d34297a750d8ab3d2e57f6d8b988"
  license "LGPL-2.0-or-later"

  bottle do
    sha256 arm64_tahoe:   "cb9f1624d4c79471a0e1b01d11b8c7c1a20f974891f23877fa2a432c62e91aa9"
    sha256 arm64_sequoia: "04c9e2681cf67eefc119d11ac7f2565cf4c53b9b7d901bfc503f21ba56ac1b00"
    sha256 arm64_sonoma:  "68f66562efcb4514d9cd2bcbf936859a52380166f36152f7213779c86ce0bdf0"
    sha256 sonoma:        "292f968c8038ad0cdeeded5f4ff3bf4a01396fbad93a0c0b453530a23f319046"
    sha256 arm64_linux:   "af1a6f406501df5cbf78b25665e1430579306b5ea5cf79e1c3fb64d709c64283"
    sha256 x86_64_linux:  "b701cf5a66a2ea0770f66a3f514820c0679674498e828007242ef412616c4859"
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

  # Apply commit from open PR to fix macOS build. Can remove if one of following PRs are part of release:
  # Ref: https://github.com/polkit-org/polkit/pull/629
  # Ref: https://github.com/polkit-org/polkit/pull/624
  patch do
    url "https://github.com/polkit-org/polkit/commit/33330b0feaa36fc8a3637e7d36f792cebd421687.patch?full_index=1"
    sha256 "d306d0eeebc2c950582a46bdbaf19180f371574e2fb71080ffc247597f2e7e4b"
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
