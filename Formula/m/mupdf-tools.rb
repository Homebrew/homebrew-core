class MupdfTools < Formula
  desc "Lightweight PDF and XPS viewer"
  homepage "https://mupdf.com/"
  url "https://mupdf.com/downloads/archive/mupdf-1.24.11-source.tar.gz"
  sha256 "191227b96775f6705ef7d9551187511932b519273b34535a331491cf7d98163f"
  license "AGPL-3.0-or-later"
  head "https://git.ghostscript.com/mupdf.git", branch: "master"

  livecheck do
    formula "mupdf"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6ff26d7eb5ffe6f579041d2dd002e4ced6c58b5782ba95a1b4ac133736f40355"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9e2dc09678635eb449fdded857cc554482fb748762e6f30b81914ea94c8168ac"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a5f93508e704a6abb233aa7bc1230e86f6d699416b3823a80cd5819df2a0bf68"
    sha256 cellar: :any_skip_relocation, sonoma:        "d889a148ae2007225ed073f38a5e628d998240e1e37d7e0b50aa106f195e2499"
    sha256 cellar: :any_skip_relocation, ventura:       "8c53edbcbd6ab91b53a146c2d299c86147a94ce7d52922ddf808370cff1cec66"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d30f2852dd0966241313d9bfe69b829bd4880cd7aa1a618611b3dae220b073fa"
  end

  conflicts_with "mupdf", because: "mupdf and mupdf-tools install the same binaries"

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
