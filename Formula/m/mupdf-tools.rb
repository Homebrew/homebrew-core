class MupdfTools < Formula
  desc "Lightweight PDF and XPS viewer"
  homepage "https://mupdf.com/"
  url "https://mupdf.com/downloads/archive/mupdf-1.27.1-source.tar.gz"
  sha256 "5a1fce7373048a3e8985d6616ee37caaa1885ab90c1b0b3956bdb53d6ecd22af"
  license "AGPL-3.0-or-later"
  head "git://git.ghostscript.com/mupdf.git", branch: "master"

  livecheck do
    formula "mupdf"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1bd2bbb92c79e573343c19d68e7f08eb23bbe29bc8cb8b7d7cdc0fd98ede68ab"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f86cfb8bce28a1b80cb7e0f38df94536820817b3b31203eef47cd169065dd17e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5c748c2358e9dc6679421b8bf9588da3cacca3e218731e56ae35cb64ed762b19"
    sha256 cellar: :any_skip_relocation, sonoma:        "22a594e304227c50b9e9b13e5a0928d021b663747eafbcc9e6f8f766ebcbbd11"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "549f0fe4ba119d4a6f9db5b5462527ffd3534f543e229eb77452bdc52d303731"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a738ce48e87b932ac5b35d81d6a90edb35592cc60901375697e14dc301516c56"
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
