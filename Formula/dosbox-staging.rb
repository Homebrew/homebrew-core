class DosboxStaging < Formula
  desc "Modernized DOSBox soft-fork"
  homepage "https://dosbox-staging.github.io/"
  url "https://github.com/dosbox-staging/dosbox-staging/archive/v0.80.1.tar.gz"
  sha256 "2ca69e65e6c181197b63388c60487a3bcea804232a28c44c37704e70d49a0392"
  license "GPL-2.0-or-later"
  head "https://github.com/dosbox-staging/dosbox-staging.git", branch: "main"

  # New releases of dosbox-staging are indicated by a GitHub release (and
  # an announcement on the homepage), not just a new version tag.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 arm64_ventura:  "b00a29063432c1b0faf3b69b29c26f6e8b546f97ac369f84020f504faa8780cd"
    sha256 arm64_monterey: "9651be9246f2adf83439b29be9bde3db1e5bed02e866daccdf75cbfc2e2cf0a2"
    sha256 arm64_big_sur:  "3c2ee227b902fde137ec5cbd38bfb8c7c15863198816b9d385d3101c260050bf"
    sha256 ventura:        "bb3d548fdf47d47db8e1087fb75a9535370c6eaeadbd1798ecd0c0180a97a102"
    sha256 monterey:       "e8f79b90a0df3ccc62b52cfad2704ac06db9834ff4732bc44dd4b7a500c79b19"
    sha256 big_sur:        "1804f6088cb72c504d1abf62c842dfa3692a77e720689316a3ce552f0e6d37f4"
    sha256 x86_64_linux:   "70bfcc3f4a894c587f24dad63bc75fd8ac972f66709cfa2e900e3811188fc07e"
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
    (buildpath/"subprojects").rmtree # Ensure we don't use vendored dependencies
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
