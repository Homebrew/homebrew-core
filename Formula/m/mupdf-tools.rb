class MupdfTools < Formula
  desc "Lightweight PDF and XPS viewer"
  homepage "https://mupdf.com/"
  url "https://mupdf.com/downloads/archive/mupdf-1.26.1-source.tar.gz"
  sha256 "bdce017c776744c288b02102977ee0378cb436c78df8127a23f281f1360406fd"
  license "AGPL-3.0-or-later"
  head "https://git.ghostscript.com/mupdf.git", branch: "master"

  livecheck do
    formula "mupdf"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c98c5150deef73eeeb516ac27e653f96335d15c889130962528d906daed73d4f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1b7d4c7c4dffc5524685f4cd6e70215e9a506ddf2294a38fe2422d9b2031f322"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c99c6727eb9d4e93ce7628d695da2d3648476b608d2102e5811f007cce67285f"
    sha256 cellar: :any_skip_relocation, sonoma:        "7239f1223ce375613ad407001121d5fdb7a077132b62b14b453bee12b452637f"
    sha256 cellar: :any_skip_relocation, ventura:       "9986b50de9b1fb82966fd2149bd574137db30ccf96ed967952b9b21aef0cc82a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9bd5372c7b5a2544200194089d0a9ee686a14344a2edf033991b52d2fced4377"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ae8d628af41f01feb4bbb7854875dd7ed7105a97e9d5524a49b0d4aee12c54b8"
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
