class MupdfTools < Formula
  desc "Lightweight PDF and XPS viewer"
  homepage "https://mupdf.com/"
  url "https://mupdf.com/downloads/archive/mupdf-1.14.0-source.tar.gz"
  sha256 "c443483a678c3fc258fa4adc124146225d0bb443c522619faadebf6b363d7724"
  head "https://git.ghostscript.com/mupdf.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "145ff51125e52e946f67b8ef71c76a66d529e496de5a369c8649971cf55e1960" => :mojave
    sha256 "efbf6d0fc63b64b1fb934446f85613dc33f71d9ed4197bb59902ad068c2df482" => :high_sierra
    sha256 "1d5fd02807e08b2888e0bf26967d3177ea8c25b0980751a9428184478bdc567b" => :sierra
  end

  def install
    system "make", "install",
           "build=release",
           "verbose=yes",
           "HAVE_X11=no",
           "CC=#{ENV.cc}",
           "prefix=#{prefix}"

    # Symlink `mutool` as `mudraw` (a popular shortcut for `mutool draw`).
    bin.install_symlink bin/"mutool" => "mudraw"
    man1.install_symlink man1/"mutool.1" => "mudraw.1"
  end

  test do
    assert_match "Homebrew test", shell_output("#{bin}/mutool draw -F txt #{test_fixtures("test.pdf")}")
  end
end
