class MupdfTools < Formula
  desc "Lightweight PDF and XPS viewer"
  homepage "https://mupdf.com/"
  url "https://mupdf.com/downloads/archive/mupdf-1.26.12-source.tar.gz"
  sha256 "6baf910928f404167ba49be6340195dec340795724722b331f5a2143f5aa0d01"
  license "AGPL-3.0-or-later"
  head "git://git.ghostscript.com/mupdf.git", branch: "master"

  livecheck do
    formula "mupdf"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b7fcbcd905d6075c5ad85407c6c8da20a34999e80b9a6df14f4e39fa849f929b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3d72533077c686972421cec9ed9409bdb48b595db7ad51cd0004f488a7c1a7b2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dfc312516e53e7af123a7880849d47cdf37f83c90c804d9a161db94f56f0a6d9"
    sha256 cellar: :any_skip_relocation, sonoma:        "1961051d083a8f9554c79dc621a6ad869b2691dd10b1436ae3cd666602431090"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4bde813d0240ea7bfd50845be335d340085e462e5994da0f0bdc4c84941d298e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "109dcb4a25f4321e8a025420fecf6d5754ed65a08510352747b2e043cd4541fa"
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
