class Mupdf < Formula
  desc "Lightweight PDF and XPS viewer"
  homepage "https://mupdf.com/"
  url "https://mupdf.com/downloads/archive/mupdf-1.15.0-source.tar.xz"
  sha256 "565036cf7f140139c3033f0934b72e1885ac7e881994b7919e15d7bee3f8ac4e"
  revision 1
  head "https://git.ghostscript.com/mupdf.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "fb6b298d8e7d01948271e6c91f00a82c2c26217ea528ecfebcfc7e16c19a598a" => :mojave
    sha256 "0058023a86332af7cc136f8d0763e832bd4fda72f6d22220ec2847407b2a21ca" => :high_sierra
    sha256 "eea95ab5ecb7a3c406c3c27c477a0440d8ed65f0db7ece2538905a6f42e7bcbc" => :sierra
  end

  depends_on "openssl@1.1"
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
