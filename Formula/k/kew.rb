class Kew < Formula
  desc "Command-line music player"
  homepage "https://github.com/ravachol/kew"
  url "https://github.com/ravachol/kew/archive/refs/tags/v4.0.0.tar.gz"
  sha256 "6162d87db4013b0611eafb2b0ec1c7882d28b8d703dc9593dc38a3ad2e88f787"
  license "GPL-2.0-only"
  head "https://github.com/ravachol/kew.git", branch: "main"

  bottle do
    sha256 arm64_tahoe:   "f6e68fd3e72c6cac5d67d04f471f2900d7271879ccd3e5b1529261846130f1ab"
    sha256 arm64_sequoia: "26bd0cc6e88f21569f6268d05937be2ff206894c5ca08c5c31e0c62bc1ca6eda"
    sha256 arm64_sonoma:  "758165796bf2e8e670559675b547d4d597283a5624658f0b7e9b77d5717e869f"
    sha256 sonoma:        "3e18b5c6e512ed5b7cc6f18b821d36014336475f79c442bf14185201bf95a942"
    sha256 arm64_linux:   "e3abf0806a388c3c3805a74a5c42c3cf3cc1fded516e0a4278487ddd090a0851"
    sha256 x86_64_linux:  "902fc7684c2511b7d10034390c00fe99d92022789670015d8590078d60cf4bee"
  end

  depends_on "pkgconf" => :build
  depends_on "chafa"
  depends_on "faad2"
  depends_on "fftw"
  depends_on "glib"
  depends_on "libogg"
  depends_on "libvorbis"
  depends_on "opus"
  depends_on "opusfile"
  depends_on "taglib"

  uses_from_macos "curl"

  on_macos do
    depends_on "gdk-pixbuf"
    depends_on "gettext"
  end

  on_linux do
    depends_on "libnotify"
  end

  def install
    system "make", "install", "PREFIX=#{prefix}", "LANGDIRPREFIX=#{prefix}"
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
