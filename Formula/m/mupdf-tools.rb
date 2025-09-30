class MupdfTools < Formula
  desc "Lightweight PDF and XPS viewer"
  homepage "https://mupdf.com/"
  url "https://mupdf.com/downloads/archive/mupdf-1.26.10-source.tar.gz"
  sha256 "1653f35bd8fbd970f05523efdc7f86e41e9728e2564a3295296e03cf59a51437"
  license "AGPL-3.0-or-later"
  head "git://git.ghostscript.com/mupdf.git", branch: "master"

  livecheck do
    formula "mupdf"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b2b715072807f55a1c8364c3475ef25c16c014be59c3231963748f6193cb5f72"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5567857b5fe3c99be2c6c723b5d58da086113efb88d0eda11235508645910605"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2cfc03c6616a8a716caf202cf95b29c44fb8b8d7c1265a24132b2d09d793fb30"
    sha256 cellar: :any_skip_relocation, sonoma:        "2d9e1d328dda9a60a5fac46926e782c63655bf03a090ae03cc2d842aec67e88e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a2791ba66ed48a345b4873ed0e6c3628461f077783bb9d5ea013eb1a4729d65d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ac6cf2d402c94b4c41139c9653bb71919e161fe84cb95b7fc18802d8d28e6d5b"
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
