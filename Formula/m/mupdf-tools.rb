class MupdfTools < Formula
  desc "Lightweight PDF and XPS viewer"
  homepage "https://mupdf.com/"
  url "https://mupdf.com/downloads/archive/mupdf-1.24.10-source.tar.gz"
  sha256 "939285b5f97caf770fd46cbe7e6cc3a695ab19bb5bfaf5712904549cef390b7b"
  license "AGPL-3.0-or-later"
  head "https://git.ghostscript.com/mupdf.git", branch: "master"

  livecheck do
    formula "mupdf"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a2b2aef22e249ec3a853a17e8f0778bc0c1f370f1474a3e32b2d1582464942fd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "25f5c45da450d2564c7d576f693c6f80356a5a17906cd42ccb1c4406df1ba6c9"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b375d902517b52b76dff9a4b00bbe85b646155823a48e33979201fd67554559d"
    sha256 cellar: :any_skip_relocation, sonoma:        "dbd0dd02a5634e4252691dac2d892835bbd7e2138a92e4914f10a55748c4671f"
    sha256 cellar: :any_skip_relocation, ventura:       "6a4ee331553caec1b524dfb020eefd2c5b7f33830937c269085be60fdb19bfdb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8a87bd6a80ffb48e37817fddd69d084503176b68ad61bf9f32e96fead4e647a0"
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
