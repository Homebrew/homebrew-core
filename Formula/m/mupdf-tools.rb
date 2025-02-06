class MupdfTools < Formula
  desc "Lightweight PDF and XPS viewer"
  homepage "https://mupdf.com/"
  url "https://mupdf.com/downloads/archive/mupdf-1.25.4-source.tar.gz"
  sha256 "74b943038fe81594bf7fc5621c60bca588b2847f0d46fb2e99652a21fa0d9491"
  license "AGPL-3.0-or-later"
  head "https://git.ghostscript.com/mupdf.git", branch: "master"

  livecheck do
    formula "mupdf"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "727a601e288b7e11df81b9cb71945a6aa6d493fa957c33edaa330c90580497de"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "baffa9611ec8db80943824cd7395fbc3949630abc22deb7e222b87f8c2bad3c7"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "15c0f30799717d1d9f09ced41d0b61060bb0bfeadb5ff7ca196f0aa2f65d8e8d"
    sha256 cellar: :any_skip_relocation, sonoma:        "1f658ab01b5f3ad00c3956fd508ef44c1d6a9d45b1eb86312b645e5503deda4d"
    sha256 cellar: :any_skip_relocation, ventura:       "0ea1b2fc500671686c4ffe58fe38e156e95e96db7e7848cdf61ca1c1b457652e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7d5515a4a9116d4f33b82d5256f8159ffe45ea56714682c3a122a1d04de11a65"
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
