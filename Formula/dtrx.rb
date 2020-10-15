class Dtrx < Formula
  desc "Intelligent archive extraction"
  homepage "https://brettcsmith.org/2007/dtrx/"
  url "https://brettcsmith.org/2007/dtrx/dtrx-7.1.tar.gz"
  mirror "https://fossies.org/linux/privat/dtrx-7.1.tar.gz"
  sha256 "1c9afe48e9d9d4a1caa4c9b0c50593c6fe427942716ce717d81bae7f8425ce97"
  license "GPL-3.0"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "ff3e436e50818837831ef16ca26f7d2760603bdd44d97fffefdc28dcde5fed2b" => :catalina
    sha256 "a63cfb21c2db4163521db20851b581d739a6707315fbb0f690f470ff697c8965" => :mojave
    sha256 "a63cfb21c2db4163521db20851b581d739a6707315fbb0f690f470ff697c8965" => :high_sierra
  end

  depends_on "p7zip"
  depends_on "unrar"

  def install
    system "python", "setup.py", "install", "--prefix=#{prefix}"
  end

  test do
    system "#{bin}/dtrx", "--version"
  end
end
