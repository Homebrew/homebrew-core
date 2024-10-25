class Kew < Formula
  desc "Command-line music player"
  homepage "https://github.com/ravachol/kew"
  url "https://github.com/ravachol/kew/archive/refs/tags/v3.0.0.tar.gz"
  sha256 "3a6dad87b76ecd59a4c6a2517738cd3b7bd831fcafe1d741fcc5b285532bdbd4"
  license "GPL-2.0-only"
  head "https://github.com/ravachol/kew.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, x86_64_linux: "1627ced1f49f804a87cb6782e848a161751b953553ad034878747078c2c0fb78"
  end

  depends_on "pkg-config" => :build
  depends_on "chafa"
  depends_on "ffmpeg"
  depends_on "fftw"
  depends_on "freeimage"
  depends_on "glib"
  depends_on "libnotify"
  depends_on "libvorbis"
  depends_on :linux
  depends_on "opusfile"
  depends_on "taglib"

  def install
    system "make"
    system "make", "install", "PREFIX=#{prefix}"

    man1.install "docs/kew.1"
  end

  test do
    (testpath/".config/kewrc").write ""
    system bin/"kew", "path", testpath

    output = shell_output("#{bin}/kew song")
    assert_match "No Music found.\nPlease make sure the path is set correctly", output

    assert_match version.to_s, shell_output("#{bin}/kew --version")
  end
end
