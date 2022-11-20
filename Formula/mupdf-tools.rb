class MupdfTools < Formula
  desc "Lightweight PDF and XPS viewer"
  homepage "https://mupdf.com/"
  url "https://mupdf.com/downloads/archive/mupdf-1.20.3-source.tar.lz"
  sha256 "6f73f63ef8aa81991dfd023d4426a548827d1d74e0bfcf2a013acad63b651868"
  license "AGPL-3.0-or-later"
  head "https://git.ghostscript.com/mupdf.git", branch: "master"

  livecheck do
    formula "mupdf"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a2438ae05dcb1ef7bb9f5ebca7945f71755ab73b4574c795923becc1b686b853"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "41191fc373b044131cc1ed3b9aad1de872a1a32fd39fd56adf038ae6d2f4b7a5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d533e660ecbe75c8e8927da7a87a47465f4fb26feb1721a118a61a80fe3951b4"
    sha256 cellar: :any_skip_relocation, ventura:        "aa0894a011a39ef42fd7d9cd1b943f4187d115153cc0daa64ec6292da677dce3"
    sha256 cellar: :any_skip_relocation, monterey:       "b490fa3f2b2ef313e41a6d8d566b1b69e773692db943e897295c4a0f86d32423"
    sha256 cellar: :any_skip_relocation, big_sur:        "c87e54708bf332210409d815ec7e67d104449ae7f9fced53f5a64cf9a351984f"
    sha256 cellar: :any_skip_relocation, catalina:       "c0bc5f50252fef1e51c7cec6054d800963a4b75ad840ff49989e60f01c833b6a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "08eeb40785dc9d29373080fdf29b64df4dde77abec3d9c4ef07deff64cc6003e"
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
