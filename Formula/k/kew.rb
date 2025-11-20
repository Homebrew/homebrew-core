class Kew < Formula
  desc "Command-line music player"
  homepage "https://github.com/ravachol/kew"
  url "https://github.com/ravachol/kew/archive/refs/tags/v3.6.4.tar.gz"
  sha256 "0f8db62bda7cf41ede9c41a5132d78537d96f90ef9e06fc5072a509a9f3b30bd"
  license "GPL-2.0-only"
  head "https://github.com/ravachol/kew.git", branch: "main"

  bottle do
    sha256 arm64_tahoe:   "328327f6c560c6a291b1fafa0cb7449c9c92c3dce3265a97e22f4ad74977e25b"
    sha256 arm64_sequoia: "9f461abff3e0a3da44d457397c3be044f006a427a98c954e3aca2adbaceb1119"
    sha256 arm64_sonoma:  "599974a7d64a8828a9ef5306198321172ced4d7548f47ffb672993c69e5c5de5"
    sha256 sonoma:        "d9febe83271d5b66de98636a86aeca31e78bc7863541898725c8a090029e00d1"
    sha256 arm64_linux:   "4e6e0c92cea8b2a77faa5cb64202023fdc441fc52af05adda96dc53da9e819c4"
    sha256 x86_64_linux:  "4ee9d87daee8e52d63e109b9f15a4ebf600222d5f10773efa9fe2857111d7fb9"
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
