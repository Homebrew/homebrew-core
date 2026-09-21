class Kew < Formula
  desc "Command-line music player"
  homepage "https://github.com/ravachol/kew"
  url "https://github.com/ravachol/kew/archive/refs/tags/v4.3.4.tar.gz"
  sha256 "1e40ba55a0f98cfde5dd5c85ff7b2de2569f7595576861eb90505fc7c2c75c15"
  license "GPL-2.0-or-later"
  head "https://github.com/ravachol/kew.git", branch: "main"

  bottle do
    sha256 arm64_golden_gate: "52f5b9b54bc51ff90f585c77d5b420aa1e5efc763d5bbf68852bd45b83d1085b"
    sha256 arm64_tahoe:       "5de2641ab52461b3d426c4fa6d14f33efe224489af5373d25a5876c4739bb62a"
    sha256 arm64_sequoia:     "17855044b5f99a1a446af18947bcb165969df4ba82867a9c3f46ff4442b28732"
    sha256 arm64_linux:       "78fc680846e9a704232d3c3fa4d3ad4f91ca33593644c20134dba5ed468382e3"
    sha256 x86_64_linux:      "37749aaf9a33c5cef07def7890350eb80180de17d404654fa42bd3068da973f9"
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
    ENV["XDG_STATE_HOME"] = testpath/".local/state"

    (testpath/".config/kew").mkpath
    (testpath/".local/state").mkpath
    (testpath/".config/kew/kewrc").write ""

    system bin/"kew", "path", testpath

    output = shell_output("#{bin}/kew song")
    assert_match "No Music found.\nPlease make sure the path is set correctly", output

    assert_match version.to_s, shell_output("#{bin}/kew --version")
  end
end
