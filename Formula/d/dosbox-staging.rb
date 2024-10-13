class DosboxStaging < Formula
  desc "Modernized DOSBox soft-fork"
  homepage "https://dosbox-staging.github.io/"
  license "GPL-2.0-or-later"
  head "https://github.com/dosbox-staging/dosbox-staging.git", branch: "main"

  stable do
    url "https://github.com/dosbox-staging/dosbox-staging/archive/refs/tags/v0.81.2.tar.gz"
    sha256 "6676a3b6957c144a80ca8c3ffec2a0bec0320274382f23af9c57dd1c20b2eb1b"

    # Backport fix to bypass SDL wraps on macOS
    patch do
      url "https://github.com/dosbox-staging/dosbox-staging/commit/9f0fc1dc762010e5f7471d01c504d817a066cae3.patch?full_index=1"
      sha256 "20b009216d877138802c698fc9aa89ea1c2becc3c13c06bdcf388ffe7a63bef2"
    end
  end

  # New releases of dosbox-staging are indicated by a GitHub release (and
  # an announcement on the homepage), not just a new version tag.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 arm64_sequoia:  "48aa9079f0008e0c3e9f841f3d91ae891a27021f592918b95da2afa35b642c49"
    sha256 arm64_sonoma:   "d9c7de5c2c373cbd38b42779d5af89ca1c3efc2a236e2d1be1885db9c17404a4"
    sha256 arm64_ventura:  "b253f715e507d4a1231a11ebc5cecd3f47efea1c6d5f70ff31047bdeb9e93677"
    sha256 arm64_monterey: "9ec95a30a281c9aad5be2661f76ae7dbb931da3f9459ccc105769beb829e260c"
    sha256 sonoma:         "76a1633bbde50f79c9f5d93ddc1c90706b9b145d792aba00d0c1ec78e002cab5"
    sha256 ventura:        "eef0af318fbd3fcc85fc8285ebe8308e9385a18c49beba38eb0d2d7bbc7aa1fb"
    sha256 monterey:       "b94ee1b1cca29f8bf00be43aeff3eeacf93bbf77da4ab710b1ded3c53ebb3f84"
    sha256 x86_64_linux:   "dda24c081c9437844203c3624888ab07298f74c0b29f5dca250c9e071b764a7f"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
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

  fails_with gcc: "5"

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
