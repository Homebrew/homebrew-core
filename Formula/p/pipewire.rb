class Pipewire < Formula
  desc "Server and user space API to deal with multimedia pipelines"
  homepage "https://pipewire.org"
  url "https://gitlab.freedesktop.org/pipewire/pipewire/-/archive/1.6.12/pipewire-1.6.12.tar.gz"
  sha256 "73dd5d5c7e67993d33de0930df5189bd5cb8883d8e3c81ab7866b1370f029eb3"
  license all_of: [
    "MIT",
    "GPL-2.0-only",      # libjackserver.so
    "LGPL-2.1-or-later", # libspa-alsa.so
  ]
  compatibility_version 1
  head "https://gitlab.freedesktop.org/pipewire/pipewire.git", branch: "master"

  # We restrict matching to versions with an even-numbered minor version number,
  # as an odd-numbered minor version number indicates a development version:
  # https://gitlab.gnome.org/GNOME/libdex/-/issues/22#note_2368290
  livecheck do
    url :stable
    regex(/^v?(\d+\.\d*[02468](?:\.\d+)*)$/i)
  end

  bottle do
    manifest_sha256 "ee48794fe643e7d02cb321471fbc9450ca1f724f25413cb70a1451f57c4e76ab"
    sha256 arm64_linux:  "cc383a4e3e151ad5844be9ad095a22c508e3ca75b36fc5f09ec2e10e88fd9cb8"
    sha256 x86_64_linux: "c9fea09d24edb3a836a7f88c2557414970825924ebf79768740cb6d6b9a7e14a"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => [:build, :test]
  depends_on "alsa-lib"
  depends_on "dbus"
  depends_on "fftw"
  depends_on "glib"
  depends_on "libsndfile"
  depends_on :linux
  depends_on "ncurses"
  depends_on "openssl@4"
  depends_on "opus"
  depends_on "pulseaudio"
  depends_on "readline"
  depends_on "systemd"

  def install
    args = %W[
      -Dexamples=disabled
      -Dgstreamer=disabled
      -Dgstreamer-device-provider=disabled
      -Dsession-managers=[]
      -Dsysconfdir=#{etc}
      -Dtests=disabled
      -Dudevrulesdir=#{lib}/udev/rules.d
    ]

    system "meson", "setup", "build", *args, *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <pipewire/pipewire.h>
      #include <assert.h>

      int main() {
        pw_init(NULL, NULL);

        // https://gitlab.freedesktop.org/pipewire/pipewire/-/blob/193384b26aba3917d086ac3f009aa2cab9d197d2/src/pipewire/version.h.in#L25-L27
        assert(pw_check_library_version(PW_MAJOR, PW_MINOR, PW_MICRO));

        pw_deinit();
        return 0;
      }
    C

    flags = shell_output("pkgconf --cflags --libs libpipewire-0.3").chomp.split
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end
