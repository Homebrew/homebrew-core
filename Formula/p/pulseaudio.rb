class Pulseaudio < Formula
  desc "Sound system for POSIX OSes"
  homepage "https://wiki.freedesktop.org/www/Software/PulseAudio/"
  license all_of: ["GPL-2.0-or-later", "LGPL-2.1-or-later", "BSD-3-Clause"]
  revision 1
  compatibility_version 1
  head "https://gitlab.freedesktop.org/pulseaudio/pulseaudio.git", branch: "master"

  stable do
    url "https://www.freedesktop.org/software/pulseaudio/releases/pulseaudio-17.0.tar.xz"
    sha256 "053794d6671a3e397d849e478a80b82a63cb9d8ca296bd35b73317bb5ceb87b5"

    # Backport fix to run on macOS
    patch do
      url "https://gitlab.freedesktop.org/pulseaudio/pulseaudio/-/commit/c1990dd02647405b0c13aab59f75d05cbb202336.diff"
      sha256 "46505b7f915a96a4e5f4c46cd8a2cfb5a74586bfd585d69f31b7b2e27e17a4c8"
      type :backport
      resolves "https://gitlab.freedesktop.org/pulseaudio/pulseaudio/-/issues/3808"
    end
  end

  # The regex here avoids x.99 releases, as they're pre-release versions.
  livecheck do
    url :stable
    regex(/href=["']?pulseaudio[._-]v?((?!\d+\.9\d+)\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_golden_gate: "76c4d4eea0d3f8a452577dd6083cb1961866fb4a2d3062c9bfbf415c70e681d0"
    sha256 arm64_tahoe:       "205b0d4e91803d44c893af002afd2d001f61edc426f7aa332b55994b86834a7a"
    sha256 arm64_sequoia:     "1a26b32a8d3e13d7d9c31b0ab2c0caef7846fcc2b148704254b555e1f8579e6d"
    sha256 arm64_linux:       "cc6e054232730f6d80dbdd2688a71c38b812e83f315aaedb3dbaef9fa0bc1b6e"
    sha256 x86_64_linux:      "b6b965cbc6a3940f66034eb7322c8e1d0aab980f72a7625f879fed8c2a2a3edb"
  end

  depends_on "gettext" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build
  depends_on "glib"
  depends_on "libsndfile"
  depends_on "libsoxr"
  depends_on "libtool"
  depends_on "openssl@4"
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
      ENV.prepend_path "PERL5LIB", formula_opt_libexec("perl-xml-parser")/"lib/perl5"
      "enabled"
    else
      "disabled"
    end

    # Default `tdb` database isn't available in Homebrew
    args = %W[
      --sysconfdir=#{etc}
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

    # Don't hardcode Cellar references in configuration files
    inreplace etc.glob("pulse/*").select(&:file?), prefix, opt_prefix, audit_result: false

    # Create the `default.pa.d` directory to avoid error messages like
    # https://github.com/Homebrew/homebrew-core/issues/224722
    (etc/"pulse/default.pa.d").mkpath
    touch etc/"pulse/default.pa.d/.keepme"
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
