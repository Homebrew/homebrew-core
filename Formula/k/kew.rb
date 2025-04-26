class Kew < Formula
  desc "Command-line music player"
  homepage "https://github.com/ravachol/kew"
  url "https://github.com/ravachol/kew/archive/refs/tags/v3.2.0.tar.gz"
  sha256 "40756969ded1a9737424e13b62c75b77d08443102b575719c778b5dc7fa71cfc"
  license "GPL-2.0-only"
  head "https://github.com/ravachol/kew.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "fb458c730ff3da5c7c68c2ab19fdee940d4677e408cfdfa262f88770530dd4ef"
    sha256 cellar: :any,                 arm64_sonoma:  "2e160a6f5312d7194d4ffc9c45730ce27806e926ac3227ed26b0c046ee840a41"
    sha256 cellar: :any,                 arm64_ventura: "9f297a7954d16c78faf96cdeb4874d76bae7406427235622eb6ad9356d58254e"
    sha256 cellar: :any,                 sonoma:        "4f1abf27cce2f67541cbc3be72cf786f70895d1e55ab0854f3353312fe4de292"
    sha256 cellar: :any,                 ventura:       "84b3695ca0923939efcc527a4515a4531046a510b89827a29aa9878ce997cd28"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1e25084ebc9dc136585a054523be686fab400ea0cddc06cd07d6bd2b2eaf0164"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6a413e23a69f0924dab1dff41ce5bedb987031ecd198022a153e57c62092561d"
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

  uses_from_macos "curl"

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
