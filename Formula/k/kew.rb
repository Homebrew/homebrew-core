class Kew < Formula
  desc "Command-line music player"
  homepage "https://github.com/ravachol/kew"
  url "https://github.com/ravachol/kew/archive/refs/tags/v3.3.3.tar.gz"
  sha256 "114edb5eead345a5311cdfecda15bf935c1c30ae1f78f97f1a5c3518e829b690"
  license "GPL-2.0-only"
  head "https://github.com/ravachol/kew.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "1eb528a5d86c0d323893475db6e338fec41d0a2a96524c07723ef57a083e3917"
    sha256 cellar: :any,                 arm64_sonoma:  "5e23b0779f4099e22b06e7e03e3179d34f3bff188f24af9748cfe2947520715b"
    sha256 cellar: :any,                 arm64_ventura: "82230366bf3f8b7df82d7ba21e24f7f87b7762ea3d12b27a2ce1f68ccaccca11"
    sha256 cellar: :any,                 sonoma:        "a35814d5ab11476f9b463846d3d7cd910926c149adc4b3a94e9825e0ed8961b7"
    sha256 cellar: :any,                 ventura:       "6a00129fb4c1a12ae1464b4132b6d98d231d0dc12d618dc767f162edbce64409"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c680304658cf72393014732165a32826fcedf5b91cf97abb28b0a57a63c0114b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "eb22fcd28b51df5c37d6d842e86ab0659a360ea65b3a9f55022a0331c037dca9"
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
    depends_on "gettext"
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
