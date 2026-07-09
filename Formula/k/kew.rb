class Kew < Formula
  desc "Command-line music player"
  homepage "https://github.com/ravachol/kew"
  url "https://github.com/ravachol/kew/archive/refs/tags/v4.1.8.tar.gz"
  sha256 "d76416787f93c64e1dd05288d42fa9683006e1307fc9c094bc2c990151835a1d"
  license "GPL-2.0-or-later"
  head "https://github.com/ravachol/kew.git", branch: "main"

  bottle do
    sha256 arm64_tahoe:   "6ecc07cb9a8295e96ccddbc1f034595f9bf58e1fd9b5ec1f58a7749f8944ef11"
    sha256 arm64_sequoia: "3ca0ea172a8575b1a43d324914fed109229c5902d9f963ec7b21833c239a1cd7"
    sha256 arm64_sonoma:  "5d93a16dd74a31c50f7ddb3d0eec1866da727379682dcb1ab5f8a5a83d080a7e"
    sha256 sonoma:        "1d3244783ae8671a2258b085e31e4d81449f5022c094e4bc69608827b3727b0e"
    sha256 arm64_linux:   "2fc9d8d47ca6e6635692138fdc6d0b41ce08a9294c035c41ed97d12613a35b23"
    sha256 x86_64_linux:  "46450a8dc1455aa9948b94582f9a7d5ace961eadc9c7c0ccdf351801c3448dbf"
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
