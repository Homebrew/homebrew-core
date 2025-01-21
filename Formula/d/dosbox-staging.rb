class DosboxStaging < Formula
  desc "Modernized DOSBox soft-fork"
  homepage "https://dosbox-staging.github.io/"
  url "https://github.com/dosbox-staging/dosbox-staging/archive/refs/tags/v0.82.0.tar.gz"
  sha256 "a3f63f86bf203ba28512e189ce6736cdb0273647e77a62ce47ed3d01b3b4a88d"
  license "GPL-2.0-or-later"
  head "https://github.com/dosbox-staging/dosbox-staging.git", branch: "main"

  # New releases of dosbox-staging are indicated by a GitHub release (and
  # an announcement on the homepage), not just a new version tag.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 arm64_sequoia: "b4459a8981e6641db94c96e2d32920527d94cfafb287df5506edd8fc2ac328e2"
    sha256 arm64_sonoma:  "6950d63dad00ad337f09c11dbc5817b7d7260b29afb14f87b71a3052b1fb2726"
    sha256 arm64_ventura: "64265c0ff0d6211d766f08ce22c72032c888120866ca92834980f2aa56b6a9a0"
    sha256 sonoma:        "d3573b89df240f1369d2b069012992697affb4cbc0f72666bae7f9f12f5cc023"
    sha256 ventura:       "fc3e42f4cdea9607d9f99e227e07f9d4a1d4483d36fed9017dae754d8cc6fba4"
    sha256 x86_64_linux:  "4db81ea132af948b33d6856c3b1c28b0e7c142ee9e443b55d299f46f77326822"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build
  depends_on "fluid-synth"
  depends_on "glib"
  depends_on "iir1"
  depends_on "libpng"
  depends_on "libslirp"
  depends_on "mt32emu"
  depends_on "opusfile"
  depends_on "sdl2"
  depends_on "sdl2_image"
  depends_on "sdl2_net"
  depends_on "speexdsp"

  uses_from_macos "zlib"

  on_linux do
    depends_on "alsa-lib"
    depends_on "mesa"
    depends_on "mesa-glu"
  end

  def install
    rm_r(buildpath/"subprojects") # Ensure we don't use vendored dependencies
    args = %w[-Ddefault_library=shared -Db_lto=true -Dtracy=false]

    system "meson", "setup", "build", *args, *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"

    mv bin/"dosbox", bin/"dosbox-staging"
    mv man1/"dosbox.1", man1/"dosbox-staging.1"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/dosbox-staging -version")
    config_path = OS.mac? ? "Library/Preferences/DOSBox" : ".config/dosbox"
    mkdir testpath/config_path
    touch testpath/config_path/"dosbox-staging.conf"
    output = shell_output("#{bin}/dosbox-staging -printconf")
    assert_equal testpath/config_path/"dosbox-staging.conf", Pathname(output.chomp)
  end
end
