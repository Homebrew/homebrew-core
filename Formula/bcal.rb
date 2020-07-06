class Bcal < Formula
  desc "Storage conversion and expression calculator"
  homepage "https://github.com/jarun/bcal"
  url "https://github.com/jarun/bcal/archive/v2.2.tar.gz"
  sha256 "506d17d6df35fad636d3ced425afee5921cd2b21242099b78b369cfcb5716e23"
  license "GPL-3.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "68c94f34b56865694b7229d0211f8c8c97c3ec809a260cf0c8764524cb76b8fa" => :catalina
    sha256 "d6e4bac5e11d3eb1815d370fc3a8890906833104c8e3b8c9865376bf36f1e90e" => :mojave
    sha256 "4c32b10db17857b3e7c553e3accf24e0cc6fefc54361ede1790c6e46c72fbaf1" => :high_sierra
  end

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    assert_match "9333353817", shell_output("#{bin}/bcal '56 gb / 6 + 4kib * 5 + 4 B'")
  end
end
