class Mupdf < Formula
  desc "Lightweight PDF and XPS viewer"
  homepage "https://mupdf.com/"
  url "https://mupdf.com/downloads/archive/mupdf-1.15.0-source.tar.xz"
  sha256 "565036cf7f140139c3033f0934b72e1885ac7e881994b7919e15d7bee3f8ac4e"
  revision 1
  head "https://git.ghostscript.com/mupdf.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "979ee218ac557ae601028796e2aa660af24f0bc69dcdf3b4da54bd52542dc55b" => :catalina
    sha256 "b1957abbb7174d8fad50192dc935b559207d3fb0daa480f41a7c0e862ffc2478" => :mojave
    sha256 "e4d59258d07575e2d4e6c041bb6ace980891cdbd08b8238849d721c9c6ec2195" => :high_sierra
  end

  depends_on "openssl@1.1"
  depends_on :x11

  conflicts_with "mupdf-tools",
    :because => "mupdf and mupdf-tools install the same binaries."

  def install
    # Work around Xcode 11 clang bug
    ENV.append_to_cflags "-fno-stack-check" if DevelopmentTools.clang_build_version >= 1010

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
