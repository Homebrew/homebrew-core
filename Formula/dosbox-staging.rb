class DosboxStaging < Formula
  desc "Modernized DOSBox soft-fork"
  homepage "https://dosbox-staging.github.io/"
  url "https://github.com/dosbox-staging/dosbox-staging/archive/v0.77.1.tar.gz"
  sha256 "85359efb7cd5c5c0336d88bdf023b7b462a8233490e00274fef0b85cca2f5f3c"
  license "GPL-2.0-or-later"
  revision 1
  head "https://github.com/dosbox-staging/dosbox-staging.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_monterey: "88b43a601ab9da67fc95ad8f6300ed97bb1712c88c59823ad958846b48d6c6c8"
    sha256 cellar: :any, arm64_big_sur:  "1e3a2ef4d27acdb78a630db92d2c0442ce1d31ab680d09af3c83e262821ba661"
    sha256 cellar: :any, monterey:       "540c94977bfa670042463b1b56ca86949231f87ba86058a5aaca909db8cdfe7a"
    sha256 cellar: :any, big_sur:        "8631465cffcb93e671bc1aae412f7e4444be46108cb78615fa5e6b21f3fb6aa5"
    sha256 cellar: :any, catalina:       "48cd7e24deaab11eff764602bd0c1060e500c3f9cb0bb7f67a3b547ff13065f4"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "fluid-synth"
  depends_on "libpng"
  depends_on "mt32emu"
  depends_on "opusfile"
  depends_on "sdl2"
  depends_on "sdl2_net"

  def install
    mkdir "build" do
      system "meson", *std_meson_args, "-Db_lto=true", ".."
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
