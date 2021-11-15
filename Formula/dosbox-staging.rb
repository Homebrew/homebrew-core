class DosboxStaging < Formula
  desc "Modernized DOSBox soft-fork"
  homepage "https://dosbox-staging.github.io/"
  url "https://github.com/dosbox-staging/dosbox-staging/archive/v0.77.1.tar.gz"
  sha256 "85359efb7cd5c5c0336d88bdf023b7b462a8233490e00274fef0b85cca2f5f3c"
  license "GPL-2.0-or-later"
  head "https://github.com/dosbox-staging/dosbox-staging.git"

  bottle do
    sha256 cellar: :any, arm64_monterey: "0a398c0d996c59dfd8fc0f15f431ae0cfb81c8cfaefa652321f3e81a7e2afae3"
    sha256 cellar: :any, arm64_big_sur:  "7dd4f286588301620a44495e5810974739ab4fd32cccd5b5f2396bdab0553a23"
    sha256 cellar: :any, monterey:       "b0f8a49984c9cff4a3dcc5f1314d62b8ea1faab5b5cfb74fdfc606bc2a6ab837"
    sha256 cellar: :any, big_sur:        "e2e63248f71bed815d467f3afecf49983470a3579490dd7ff60afbae1383625d"
    sha256 cellar: :any, catalina:       "01c1cf45fb8d75aeb5b81174bc02693093c047ca138ae3cf1a880c5ad1ca35eb"
    sha256 cellar: :any, mojave:         "e56e6203ef35b2402396029baba105d93127531dcc92acf5182edf06ee747f2c"
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
