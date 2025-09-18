class Kew < Formula
  desc "Command-line music player"
  homepage "https://github.com/ravachol/kew"
  url "https://github.com/ravachol/kew/archive/refs/tags/v3.4.1.tar.gz"
  sha256 "4a693d881f5f9d1ba70004c13b00ae6f75c2e592192574ac1d549a025fb3c511"
  license "GPL-2.0-only"
  head "https://github.com/ravachol/kew.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "7e97980b672aeffd8ef46a9940d956b685108c7effe4c02655c0031055fb703a"
    sha256 cellar: :any,                 arm64_sequoia: "42a93ffa2eccf067b073f91cab44b4f6a4d03a85729a706be35c94ccea2e0a84"
    sha256 cellar: :any,                 arm64_sonoma:  "f1b565c5cfafe41eb395c201002c6a1289213392ea2b048f9357a8d40b100ae8"
    sha256 cellar: :any,                 arm64_ventura: "6d49e4c7233cae8208281e236cbaad6278f836d4166647a4bfecca9a0d770cd5"
    sha256 cellar: :any,                 sonoma:        "1d0388692397f39add18f3145da7df81c6ece0fb41d167c4f73527ddcbd7bed2"
    sha256 cellar: :any,                 ventura:       "3b1ca10478e13978a3fc996ae751db187cbc9e97b7b0da089bc60c1d0dba2939"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "421e2f4dc683286c5d0e5394f96d39fa833b81de1c036836c2a25c76a5b1c7ad"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9ca4f656b73d975f590e86f37bfd9bec38710a3fe8e3b594ada346fcecbf11a1"
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
