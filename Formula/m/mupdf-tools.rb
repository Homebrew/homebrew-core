class MupdfTools < Formula
  desc "Lightweight PDF and XPS viewer"
  homepage "https://mupdf.com/"
  url "https://mupdf.com/downloads/archive/mupdf-1.28.6-source.tar.gz"
  sha256 "dc85000640a45d90ca9b77b061f6ca67cce0c4d4fbecf8819647baf573eef101"
  license "AGPL-3.0-or-later"
  head "git://git.ghostscript.com/mupdf.git", branch: "master"

  livecheck do
    formula "mupdf"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "c9094a579ac49805316b90bc1e2995290ff5f3366c0f49c6fe46d953897e8b71"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "bb15f8a48b2121cf96d4c80ca0edc3a0007b4501f77ee91cabcbbfd3b6ca896c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "69fa4ebb754360f93d635da24c1b4b95f9d747db0d2fb95fe1a8d02ffd595014"
    sha256 cellar: :any,                 arm64_linux:       "f6567ec3067d5339ade66b60e7a5a6ce8e0ea171ef0dc890e8802e28fcb119ed"
    sha256 cellar: :any,                 x86_64_linux:      "9bae2decd7bef9c7b06d10cad3b25d6154c3a53033c97df76d36df8a322302a9"
  end

  conflicts_with "mupdf", because: "mupdf and mupdf-tools install the same binaries"

  deny_network_access!

  def install
    system "make", "install",
           "build=release",
           "verbose=yes",
           "HAVE_X11=no",
           "HAVE_GLUT=no",
           "CC=#{ENV.cc}",
           "prefix=#{prefix}"

    # Symlink `mutool` as `mudraw` (a popular shortcut for `mutool draw`).
    bin.install_symlink bin/"mutool" => "mudraw"
    man1.install_symlink man1/"mutool.1" => "mudraw.1"
  end

  test do
    assert_match "Homebrew test", shell_output("#{bin}/mudraw -F txt #{test_fixtures("test.pdf")}")
  end
end
