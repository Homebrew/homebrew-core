class DosboxStaging < Formula
  desc "Modernized DOSBox soft-fork"
  homepage "https://dosbox-staging.github.io/"
  url "https://github.com/dosbox-staging/dosbox-staging/archive/v0.77.1.tar.gz"
  sha256 "85359efb7cd5c5c0336d88bdf023b7b462a8233490e00274fef0b85cca2f5f3c"
  license "GPL-2.0-or-later"
  head "https://github.com/dosbox-staging/dosbox-staging.git"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "c78a913ee0090ab3529008a820ea8884484d374f173449da27c2d4049e77c3c8"
    sha256 cellar: :any, big_sur:       "94200db2433f162408a309db31ac3f9a38c517a0d4d1a81102f2dd10949f1a46"
    sha256 cellar: :any, catalina:      "16d067fe9d67563350c6321284496be2594db58faadb9a9f3b5b001ec106fd88"
    sha256 cellar: :any, mojave:        "2861ee737fb11f2772f1de3ea8f8235c360b8064946c6c070a214c98b510482c"
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
