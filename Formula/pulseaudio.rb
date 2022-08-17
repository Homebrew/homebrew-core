class Pulseaudio < Formula
  desc "Sound system for POSIX OSes"
  homepage "https://wiki.freedesktop.org/www/Software/PulseAudio/"
  license all_of: ["GPL-2.0-or-later", "LGPL-2.1-or-later", "BSD-3-Clause"]
  head "https://gitlab.freedesktop.org/pulseaudio/pulseaudio.git", branch: "master"

  stable do
    url "https://www.freedesktop.org/software/pulseaudio/releases/pulseaudio-16.1.tar.xz"
    sha256 "8eef32ce91d47979f95fd9a935e738cd7eb7463430dabc72863251751e504ae4"

    # Make gio-2.0 optional. Remove in the next release.
    patch do
      url "https://gitlab.freedesktop.org/pulseaudio/pulseaudio/-/commit/de8b0c11242a49c335abdae292d0bb9f6d71d2dd.diff"
      sha256 "d2d259b887908b37d63564ee1eb93fa98a6bffc5600876c6181758c6ca59b95e"
    end
  end

  # The regex here avoids x.99 releases, as they're pre-release versions.
  livecheck do
    url :stable
    regex(/href=["']?pulseaudio[._-]v?((?!\d+\.9\d+)\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_monterey: "ce44a5a697ba790ab27e97f4c96cd5f48489cdfc416a836348584064053eb725"
    sha256 arm64_big_sur:  "efcbf144da932e05394e9768bf27dfa1908dbb17f4b7c52f49e56c791dd51860"
    sha256 monterey:       "835e284178eda5eaa8395aab875305d8ba528336f657844d5791f29e0216d46a"
    sha256 big_sur:        "79684acaac85e9b1b7de55fc7659844d9508c6264faa0aac311e0d8eaf4056b0"
    sha256 catalina:       "e1c181ae27f945ceee403e2e2ec80f44aebd52ac44b8e63140c1c9d2083a643b"
    sha256 mojave:         "ae0d2ec72fc10a895c7efc330174abef08458576ed847fb4547301a2d8cc147e"
    sha256 x86_64_linux:   "35c1358237eefe762c268cbbbf86015b425e8ff3bdff697afb93e8449fae2ae3"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on "libsndfile"
  depends_on "libsoxr"
  depends_on "libtool"
  depends_on "openssl@1.1"
  depends_on "speexdsp"

  uses_from_macos "perl" => :build
  uses_from_macos "expat"
  uses_from_macos "m4"

  on_linux do
    depends_on "dbus"
    depends_on "glib"
    depends_on "libcap"

    resource "XML::Parser" do
      url "https://cpan.metacpan.org/authors/id/T/TO/TODDR/XML-Parser-2.46.tar.gz"
      sha256 "d331332491c51cccfb4cb94ffc44f9cd73378e618498d4a37df9e043661c515d"
    end
  end

  def install
    if OS.linux?
      ENV.prepend_create_path "PERL5LIB", buildpath/"lib/perl5"
      resource("XML::Parser").stage do
        system "perl", "Makefile.PL", "INSTALL_BASE=#{buildpath}"
        system "make", "PERL5LIB=#{ENV["PERL5LIB"]}", "CC=#{ENV.cc}"
        system "make", "install"
      end
    end

    system "meson", *std_meson_args, "build",
                    "-Dbashcompletiondir=#{bash_completion}",
                    "-Ddatabase=simple", # Default `tdb` isn't available in Homebrew
                    "-Ddoxygen=false",
                    "-Dlocalstatedir=#{var}",
                    "-Dman=true",
                    "-Dsysconfdir=#{etc}",
                    "-Dtests=false",
                    "-Dudevrulesdir=#{lib}/udev/rules.d",
                    "-Dx11=disabled"
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
