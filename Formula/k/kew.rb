class Kew < Formula
  desc "Command-line music player"
  homepage "https://github.com/ravachol/kew"
  url "https://github.com/ravachol/kew/archive/refs/tags/v4.3.1.tar.gz"
  sha256 "4d875e0b2e9cf637193514e2fdb7600fc8722d6634e60eacaba2f7ad186bd82d"
  license "GPL-2.0-or-later"
  head "https://github.com/ravachol/kew.git", branch: "main"

  bottle do
    sha256 arm64_tahoe:   "1bc30fd82b0cd0089a997b9c483361474f9318b9875b0e4ad8f9bffcac40138c"
    sha256 arm64_sequoia: "7f13fdf1098b833e7c7727bfb87f408928315e8e3da4917c1449c4c1e81aaec6"
    sha256 arm64_sonoma:  "cc28e450fb7fc1402e6f5d6f1d4ff3515130e2976164d9a8ec1f876964e0aaa0"
    sha256 arm64_linux:   "e6376eb7414a6733dc8c6e41d7828b48146849de7abe449f5e95a600c16d4aa4"
    sha256 x86_64_linux:  "6680c2b7fa3853d3264e10cfca22652e37dc756ec9fc6e9f9306e29f58d5a732"
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

  # Fix version output, upstream PR ref, https://github.com/ravachol/kew/pull/585
  patch do
    url "https://github.com/ravachol/kew/commit/998a9eb4b84f75e65e1c5ced7325e561e459fe44.patch?full_index=1"
    sha256 "a07d3f9c4de44329ed1c76929e67b0553275eb0c369125598d0039f8eb0aa6e6"
    type :unofficial
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
