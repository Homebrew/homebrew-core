class Kew < Formula
  desc "Command-line music player"
  homepage "https://github.com/ravachol/kew"
  url "https://github.com/ravachol/kew/archive/refs/tags/v3.0.0.tar.gz"
  sha256 "3a6dad87b76ecd59a4c6a2517738cd3b7bd831fcafe1d741fcc5b285532bdbd4"
  license "GPL-2.0-only"
  head "https://github.com/ravachol/kew.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, x86_64_linux: "f88ff30a7c706d45da938069eb8e03152881c8f72fc1031e5ea2b2150398b2ff"
  end

  depends_on "pkg-config" => :build
  depends_on "chafa"
  depends_on "faad2"
  depends_on "fftw"
  depends_on "glib"
  depends_on "libvorbis"
  depends_on "opusfile"
  depends_on "taglib"
  on_linux do
    depends_on "libnotify"
  end

  def install
    ENV.prepend_path "PKG_CONFIG_PATH", Formula["glib"].opt_lib/"pkgconfig"

    system "make", "PKG_CONFIG_PATH=#{ENV["PKG_CONFIG_PATH"]}"
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
