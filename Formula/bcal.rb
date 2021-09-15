class Bcal < Formula
  desc "Storage conversion and expression calculator"
  homepage "https://github.com/jarun/bcal"
  url "https://github.com/jarun/bcal/archive/v2.2.tar.gz"
  sha256 "506d17d6df35fad636d3ced425afee5921cd2b21242099b78b369cfcb5716e23"
  license "GPL-3.0-or-later"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "4463ecf7df9456c39cd335f13be9ed5383b06abcc79304c8b5e8919adb79b005"
    sha256 cellar: :any_skip_relocation, big_sur:       "6ed62225e47369c6789c74c058aecbd83cc69056f81229d66995c33f8d8db34c"
    sha256 cellar: :any_skip_relocation, catalina:      "68c94f34b56865694b7229d0211f8c8c97c3ec809a260cf0c8764524cb76b8fa"
    sha256 cellar: :any_skip_relocation, mojave:        "d6e4bac5e11d3eb1815d370fc3a8890906833104c8e3b8c9865376bf36f1e90e"
    sha256 cellar: :any_skip_relocation, high_sierra:   "4c32b10db17857b3e7c553e3accf24e0cc6fefc54361ede1790c6e46c72fbaf1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7a7d5f7835a8de19e7e5a647cbc856291e18da0b7f3a4fbf95620f2c57dfa9cd"
  end

  on_linux do
    depends_on "readline"
  end

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    assert_match "9333353817", shell_output("#{bin}/bcal '56 gb / 6 + 4kib * 5 + 4 B'")
  end
end
