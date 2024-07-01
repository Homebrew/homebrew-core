class Kew < Formula
  desc "Command-line music player"
  homepage "https://github.com/ravachol/kew"
  url "https://github.com/ravachol/kew/archive/refs/tags/v2.5.1.tar.gz"
  sha256 "9c7ed8e6d7de91938ad9246d6ad4c63d3a556e8c58a3e765d6e84deeaeb9b484"
  license "GPL-2.0-only"
  head "https://github.com/ravachol/kew.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, x86_64_linux: "1ee5523696924ffcf200a3088f3bc15f42983e9c017d31c7ef9711cec1aa573d"
  end

  depends_on "pkg-config" => :build
  depends_on "chafa"
  depends_on "ffmpeg"
  depends_on "fftw"
  depends_on "freeimage"
  depends_on "glib"
  depends_on "libvorbis"
  depends_on :linux
  depends_on "opusfile"

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
