class MupdfTools < Formula
  desc "Lightweight PDF and XPS viewer"
  homepage "https://mupdf.com/"
  url "https://mupdf.com/downloads/archive/mupdf-1.22.1-source.tar.lz"
  sha256 "33b00317b93bc404cffb67c91a5e6bb1b62051536829171c5f75cbaf2c1ea7df"
  license "AGPL-3.0-or-later"
  head "https://git.ghostscript.com/mupdf.git", branch: "master"

  livecheck do
    formula "mupdf"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "987cbcc3089f5a8dda83662538eb08482568de53ce215a1e90624ff0163f9651"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "820c6756ebaf2632ca1a34f1f86a0b2cbca87946329e736537d891b365c8724e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "79ab952b20405b3ab34a5d34c9657f11403d2e5185873a807b42ce9dbfcafd53"
    sha256 cellar: :any_skip_relocation, ventura:        "c7bd17d3e7e0e0ed8e8a8ebd829e285d955e565d9a818fb5b61799da1e0f7782"
    sha256 cellar: :any_skip_relocation, monterey:       "8d14e584e615bcd1d83bc1d14ceb1218d62695e526b002183dab9c148f65b10f"
    sha256 cellar: :any_skip_relocation, big_sur:        "05992abf4aa2be5849e42227b15a80cf9758935a7c127c81ab52ec7a9b48f425"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8e9d82a7cab47a32bfc44d23983f1a1752f30ffe9da2888ab452354a10cfa333"
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
