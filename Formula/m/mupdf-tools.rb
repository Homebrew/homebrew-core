class MupdfTools < Formula
  desc "Lightweight PDF and XPS viewer"
  homepage "https://mupdf.com/"
  url "https://mupdf.com/downloads/archive/mupdf-1.23.11-source.tar.gz"
  sha256 "478f2a167feae2a291c8b8bc5205f2ce2f09f09b574a6eb0525bfad95a3cfe66"
  license "AGPL-3.0-or-later"
  head "https://git.ghostscript.com/mupdf.git", branch: "master"

  livecheck do
    formula "mupdf"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "bd23d0f128cda11e03c9d6b316775438f03efa8e5e244291065491729987c17a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "12bdb80c5812748e61249318839caf528ede3f3bb5c06f20c03008106aa96865"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7b5657d24084a2d1c8ca0914604dbfed407489ec60ce8980985bb2fc42536cbd"
    sha256 cellar: :any_skip_relocation, sonoma:         "b65c83248eea921dd9d0c887a9c55e36207ed322bbdc40b7e4a34e0369e326da"
    sha256 cellar: :any_skip_relocation, ventura:        "c2f3d00c39fd05f628c49a42e1575976b0dff7d1fea1a61026c7efc64c91c544"
    sha256 cellar: :any_skip_relocation, monterey:       "8e9196348789761ebd0f43d2007da44c1ed0dcf18e8caef756d9be969132afc5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b48482c03e3b6bd4639762e1d677ed25fa50090ddd6d5985e8b1476b0bf9ba20"
  end

  conflicts_with "mupdf",
    because: "mupdf and mupdf-tools install the same binaries"

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
