class DosboxStaging < Formula
  desc "Modernized DOSBox soft-fork"
  homepage "https://dosbox-staging.github.io/"
  url "https://github.com/dosbox-staging/dosbox-staging/archive/v0.77.0.tar.gz"
  sha256 "85e1739f5dfd7d96b752b2b0e12aad6f95c7770b47fcdaf978d4128d7890d986"
  license "GPL-2.0-or-later"
  revision 1
  head "https://github.com/dosbox-staging/dosbox-staging.git"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "15d72077feefaaf2e52006dfe7a7bbdb7c6db192e7629a87d078f3502a650618"
    sha256 cellar: :any, big_sur:       "15b83b2a8599ee8d1924d07ade8962288f54d6c64b485aede8ea7d725cd9490d"
    sha256 cellar: :any, catalina:      "aa250a2af78f35583af39b1f5582d2675b62a91a786670448cee33cce392b7e8"
    sha256 cellar: :any, mojave:        "eb6ea54266e0584bf06f7666f4cfaa1ea4e19988fecf14dadcc1e1472a210820"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "fluid-synth"
  depends_on "libpng"
  depends_on "opusfile"
  depends_on "sdl2"
  depends_on "sdl2_net"

  def install
    mkdir "build" do
      system "meson", *std_meson_args, "-Duse_mt32emu=false", ".."
      system "ninja", "-v"
      system "ninja", "install", "-v"
    end
    mv bin/"dosbox", bin/"dosbox-staging"
    mv man1/"dosbox.1", man1/"dosbox-staging.1"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/dosbox-staging -version")
    mkdir testpath/"Library/Preferences/DOSBox"
    touch testpath/"Library/Preferences/DOSBox/dosbox-staging.conf"
    output = shell_output("#{bin}/dosbox-staging -printconf")
    assert_equal "#{testpath}/Library/Preferences/DOSBox/dosbox-staging.conf", output.chomp
  end
end
