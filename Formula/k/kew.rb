class Kew < Formula
  desc "Command-line music player"
  homepage "https://github.com/ravachol/kew"
  url "https://github.com/ravachol/kew/archive/refs/tags/v3.4.0.tar.gz"
  sha256 "a7d19f004d05eb820fee5c43bce9d625eac1c7d7b3ab0b0181858abb97912e35"
  license "GPL-2.0-only"
  head "https://github.com/ravachol/kew.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "72efbb4eff98959c8485ccc4ee752f84757a5abdfab19ef68d84a000f0e9235d"
    sha256 cellar: :any,                 arm64_sonoma:  "fb572d340cf41403518bbe15de195fffa31847610ba57b58f28b3715b783623c"
    sha256 cellar: :any,                 arm64_ventura: "3bf31c3fa40823ffc3146ed8a4ac02cf814c4f1510ac5b3774c8d8bca5ba9508"
    sha256 cellar: :any,                 sonoma:        "40074ca7dab37969e5ab676a4174da2642ea7d40686c35d7b18a79246118b3df"
    sha256 cellar: :any,                 ventura:       "2bbc357941c68682e75cb94edcfbf87a5baa2faab28a6e6c6e28a63184f1330e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "80633ab62b7b0e3b0c5bd67a87751c558908e1f47d9c57e88333dd5310b68eb7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "08674d321e4693db7cf8f7e66c6fc5bb620129849479af4d2faf5359f51e5cae"
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
