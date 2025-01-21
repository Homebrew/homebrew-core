class MupdfTools < Formula
  desc "Lightweight PDF and XPS viewer"
  homepage "https://mupdf.com/"
  url "https://mupdf.com/downloads/archive/mupdf-1.25.2-source.tar.gz"
  sha256 "36ccf6a5e691e188acf8db6e98d08bf05f27bb4ce30432dc15fc76d329a92d4d"
  license "AGPL-3.0-or-later"
  head "https://git.ghostscript.com/mupdf.git", branch: "master"

  livecheck do
    formula "mupdf"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a2281b06b6eab5509f5689ef70aa70d4b88baf42653990f0ab040182f0539d47"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7413a69945866272c31540e8306f6f1c0633c8ab3891bed2b8dbfd0f9fd98bf6"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "418f879c3410db0a17d985359c35c8857b1137cba22afb956ad4fa05e8a0c891"
    sha256 cellar: :any_skip_relocation, sonoma:        "20a7fe61507190db5ed20abd6dc38bb5ed043c84d17aa3ce2131fefb125a0e1c"
    sha256 cellar: :any_skip_relocation, ventura:       "8b098599d4bcfe8c7c81cd2857df5ae17f2d476a7ec05f814b614f05c3c21b05"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e249ac3b12444d071eada58a9ffbef829dc06ddb1f74b584b85520d9e153e4e5"
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
