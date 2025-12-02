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

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 arm64_tahoe:   "a5fb7e3985bda5814f9eac5afa28073cc8aa1690ef73981c98c5712731e0dc4b"
    sha256 arm64_sequoia: "f279ea9efd07106c6e049b0d5bcca39a5fb06f5bd95079f998b2175726050c79"
    sha256 arm64_sonoma:  "6c8704f6c5bce3450d75da7983a9d5ef2eca52ce9ef944c85a54e8e86c9c4354"
    sha256 arm64_ventura: "8f36cbfefb820a38dce3efca6458c3837950448a59ff77337105f7f3cd550429"
    sha256 sonoma:        "43cc094dbeb0681caa68cc3ed6e3dab115a0c52ae09fb39b6e3ac16a810edd4b"
    sha256 ventura:       "26a46b5af9fa4436be2057e2c838ff5b4220cb6724ffa28ad10dec4437ba99ea"
    sha256 arm64_linux:   "cbb10721c978f2be94f38829b6f1ab941cd6dd310fc00c45ee8b1d4ebdb16ab1"
    sha256 x86_64_linux:  "0a8deac02332caf78aef95c279d76dd381ae1b08e0c8f74277880570a4d60527"
  end

  depends_on "gettext" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build
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
    inreplace etc.glob("pulse/*"), prefix, opt_prefix, audit_result: false

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
