class Pulseaudio < Formula
  desc "Sound system for POSIX OSes"
  homepage "https://wiki.freedesktop.org/www/Software/PulseAudio/"
  url "https://www.freedesktop.org/software/pulseaudio/releases/pulseaudio-17.0.tar.xz"
  sha256 "053794d6671a3e397d849e478a80b82a63cb9d8ca296bd35b73317bb5ceb87b5"
  license all_of: ["GPL-2.0-or-later", "LGPL-2.1-or-later", "BSD-3-Clause"]
  head "https://gitlab.freedesktop.org/pulseaudio/pulseaudio.git", branch: "master"

  # The regex here avoids x.99 releases, as they're pre-release versions.
  livecheck do
    url :stable
    regex(/href=["']?pulseaudio[._-]v?((?!\d+\.9\d+)\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sequoia:  "ceb92ec9cc890a989907d2b0fe1de997e619cde589fbcc5a31eda87f8adccedb"
    sha256 arm64_sonoma:   "aea71892ba21ebdc3e619819ddc6f641a59d87d0688b671b82352af062cf860b"
    sha256 arm64_ventura:  "63b0ba13d5187af0e2f9bd56f638bf2f1060c60327bb78f97f094cde6756a07c"
    sha256 arm64_monterey: "25d41b1a184588db2fdb9f39367ff6d20f6c7542f9de2e6b67b73bc4f7bd5e09"
    sha256 sonoma:         "57c4f8e47c04145f0851d231d0c92bd43f57e59bf3416689e25b8e619a7913a3"
    sha256 ventura:        "fd0835395b77a321e3b5a4542496c02dd0dbdd8134e700bacbfb80c46d6e14cc"
    sha256 monterey:       "e28e0f3a10c94b089acb2a6f82fd31d19c3cd8cbd7ad180d50a794f473b9adaa"
    sha256 x86_64_linux:   "504035dfda3bffabae42f352d0e7c0a90c6b8c1f6b925fe7e17502124d5d6529"
  end

  depends_on "gettext" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "glib"
  depends_on "libsndfile"
  depends_on "libsoxr"
  depends_on "libtool"
  depends_on "openssl@3"
  depends_on "orc"
  depends_on "speexdsp"

  uses_from_macos "perl" => :build

  on_macos do
    depends_on "gettext" # for libintl
  end

  on_linux do
    depends_on "perl-xml-parser" => :build
    depends_on "alsa-lib"
    depends_on "dbus"
    depends_on "libcap"
  end

  def install
    enabled_on_linux = if OS.linux?
      ENV.prepend_path "PERL5LIB", Formula["perl-xml-parser"].libexec/"lib/perl5"
      "enabled"
    else
      # Restore coreaudio module as default on macOS
      inreplace "meson.build", "cdata.set('HAVE_COREAUDIO', 0)", "cdata.set('HAVE_COREAUDIO', 1)"
      "disabled"
    end

    # Default `tdb` database isn't available in Homebrew
    args = %W[
      -Ddatabase=simple
      -Ddoxygen=false
      -Dman=true
      -Dtests=false
      -Dstream-restore-clear-old-devices=true

      -Dlocalstatedir=#{var}
      -Dbashcompletiondir=#{bash_completion}
      -Dzshcompletiondir=#{zsh_completion}
      -Dudevrulesdir=#{lib}/udev/rules.d

      -Dalsa=#{enabled_on_linux}
      -Ddbus=#{enabled_on_linux}
      -Dglib=enabled
      -Dgtk=disabled
      -Dopenssl=enabled
      -Dorc=enabled
      -Dsoxr=enabled
      -Dspeex=enabled
      -Dsystemd=disabled
      -Dx11=disabled
    ]

    system "meson", "setup", "build", *args, *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  service do
    run [opt_bin/"pulseaudio", "--exit-idle-time=-1", "--verbose"]
    keep_alive true
    log_path var/"log/pulseaudio.log"
    error_log_path var/"log/pulseaudio.log"
  end

  test do
    assert_match "module-sine", shell_output("#{bin}/pulseaudio --dump-modules")
  end
end
