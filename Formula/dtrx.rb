class Dtrx < Formula
  desc "Intelligent archive extraction"
  homepage "https://brettcsmith.org/2007/dtrx/"
  url "https://brettcsmith.org/2007/dtrx/dtrx-7.1.tar.gz"
  sha256 "1c9afe48e9d9d4a1caa4c9b0c50593c6fe427942716ce717d81bae7f8425ce97"

  bottle do
    cellar :any_skip_relocation
    sha256 "c88f2dfca39e978e4d49d24e88fcdb479936adcc4773cec913b312a0c6f4dc0a" => :mojave
    sha256 "c159f3897c3de8b840beb2dba4aba058262b932b06650ae72ef4c86841fcfdbe" => :high_sierra
    sha256 "812e92d3899f795921dced2d1085dec1258a659595e1a0545e67a03be653b9ca" => :sierra
    sha256 "5419cb8b5327a5770d1d8a541a11c47f9195885964af3977110a4bd752a63ff7" => :el_capitan
    sha256 "15359cfa40144872520eba6cdb132a1bfc0534b66cfd87c6efab3d57221ba66f" => :yosemite
    sha256 "c023c31dfc27c2a198ff310bfa0438fac034209f39e42800ee5d462bb2be3e6b" => :mavericks
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
