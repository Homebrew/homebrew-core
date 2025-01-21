class Kew < Formula
  desc "Command-line music player"
  homepage "https://github.com/ravachol/kew"
  url "https://github.com/ravachol/kew/archive/refs/tags/v3.0.3.tar.gz"
  sha256 "fac446e2c78b6341dff46a88767dd0b9f75a4b2b60e03fc0623b09aa28ec5bba"
  license "GPL-2.0-only"
  head "https://github.com/ravachol/kew.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "4e4be42aa4620ace00caa1f3b3865d5c87c56ba063fa1d6729be8333d55a22a0"
    sha256 cellar: :any,                 arm64_sonoma:  "fd6f2dca29cb1305aa4313f2d93df4be26747ca9bc2850154a186e4c605e7137"
    sha256 cellar: :any,                 arm64_ventura: "2e84bd91e5cb5b0d79d39f45d271398854d32fc6b231a9c10a89ccc07622eb02"
    sha256 cellar: :any,                 sonoma:        "aa5ed55a172dfca5ddc5623c23a4c2acc8e8fff944e67c55434ac91950cb9158"
    sha256 cellar: :any,                 ventura:       "01b423a432cf7f30192fdf0c24334a6aac0da4ef4c7b0a1f4bbe4d0c95ca89ea"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e1b566987f3414fc73bac5c130d52094bc419aabea6c63bd57f119c700f0a811"
  end

  depends_on "pkgconf" => :build
  depends_on "chafa"
  depends_on "faad2"
  depends_on "fftw"
  depends_on "glib"
  depends_on "libogg"
  depends_on "libvorbis"
  depends_on "opusfile"
  depends_on "taglib"

  on_macos do
    depends_on "gettext"
    depends_on "opus"
  end

  on_linux do
    depends_on "libnotify"
  end

  def install
    system "make", "install", "PREFIX=#{prefix}"
    man1.install "docs/kew.1"
  end

  test do
    ENV["XDG_CONFIG_HOME"] = testpath/".config"

    (testpath/".config/kew").mkpath
    (testpath/".config/kew/kewrc").write ""

    system bin/"kew", "path", testpath

    output = shell_output("#{bin}/kew song")
    assert_match "No Music found.\nPlease make sure the path is set correctly", output

    assert_match version.to_s, shell_output("#{bin}/kew --version")
  end
end
