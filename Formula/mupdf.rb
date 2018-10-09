class Mupdf < Formula
  desc "Lightweight PDF and XPS viewer"
  homepage "https://mupdf.com/"
  url "https://mupdf.com/downloads/archive/mupdf-1.14.0-source.tar.gz"
  sha256 "c443483a678c3fc258fa4adc124146225d0bb443c522619faadebf6b363d7724"
  head "https://git.ghostscript.com/mupdf.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "ca405c70d8a63558b50cbe379e37b7ad8eb72ff60d1318249a89ebba20929e99" => :mojave
    sha256 "533293ae8a45533a1dd70a90f736c2aa1d7858782f19248a704a30c4ddc060dc" => :high_sierra
    sha256 "30591da2955a812f833e94e852a7292a95e5e59365faa3e143aeeb7927a8cd2a" => :sierra
    sha256 "96b2f59e4f35d2efb229df4a1b7e4d8c02f4dcdb0ee4f3d95f8352d5b1cacfe8" => :el_capitan
  end

  depends_on "openssl"
  depends_on :x11

  conflicts_with "mupdf-tools",
    :because => "mupdf and mupdf-tools install the same binaries."

  def install
    system "make", "install",
           "build=release",
           "verbose=yes",
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
