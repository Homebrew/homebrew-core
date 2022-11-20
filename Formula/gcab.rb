class Gcab < Formula
  desc "Windows installer (.MSI) tool"
  homepage "https://wiki.gnome.org/msitools"
  url "https://download.gnome.org/sources/gcab/1.5/gcab-1.5.tar.xz"
  sha256 "46bf7442491faa4148242b9ec2a0786a5f6e9effb1b0566e5290e8cc86f00f0c"
  license "LGPL-2.1-or-later"

  # We use a common regex because gcab doesn't use GNOME's "even-numbered minor
  # is stable" version scheme.
  livecheck do
    url :stable
    regex(/gcab[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_ventura:  "1d0df9fc71f98941abf94db41da7453d3c110f1ad1d9d68531562236c248c31b"
    sha256 arm64_monterey: "e49e15cd9661987efd99db61dc29b244a8f9459a3bcaeba342b37c04ab31a555"
    sha256 arm64_big_sur:  "731d488b6e811c7c98feae0dd58956ae982710ab839be34a2d875adeb8b17218"
    sha256 ventura:        "28ba70d27ac7f93e0a26daf48e1b58a4305b4c4ba250145d774590e0fd5867bc"
    sha256 monterey:       "bc78f61070ee0ad6a4397db82e661d89b76b17f8217401dbdc82e76742f7deee"
    sha256 big_sur:        "e0ddb5aee18997830d3b55772a1deaaf93a8b6a488a5bc68b4188a69dedbc5ea"
    sha256 catalina:       "431ec9816bf99b859a17367933fa11e2c43498078dc423d4b759575ee1a2cbc3"
    sha256 x86_64_linux:   "d31fd6fd578719a656cc13e05570257bfc9dd0ecb057cf1a003561a5c202443b"
  end

  depends_on "gobject-introspection" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "vala" => :build
  depends_on "glib"

  # build patch for git version check, remove in next version
  patch do
    url "https://github.com/GNOME/gcab/commit/ad0baea50359c1978a9224ee60bf98d97bfb991f.patch?full_index=1"
    sha256 "e25a2f6651c7096c553c9e57a086140e666169a6520a55f7d67ccabd1c0190be"
  end

  def install
    mkdir "build" do
      system "meson", *std_meson_args, "-Ddocs=false", ".."
      system "ninja"
      system "ninja", "install"
    end
  end

  test do
    system "#{bin}/gcab", "--version"
  end
end
