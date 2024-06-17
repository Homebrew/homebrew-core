class Flawfinder < Formula
  include Language::Python::Shebang

  desc "Examines code and reports possible security weaknesses"
  homepage "https://dwheeler.com/flawfinder/"
  url "https://dwheeler.com/flawfinder/flawfinder-2.0.19.tar.gz"
  sha256 "fe550981d370abfa0a29671346cc0b038229a9bd90b239eab0f01f12212df618"
  license "GPL-2.0-or-later"
  revision 1
  head "https://github.com/david-a-wheeler/flawfinder.git", branch: "master"

  livecheck do
    url :homepage
    regex(/href=.*?flawfinder[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "29f9397a8cee6ea519559666eca9fd4323259bc449543e8bc0f4afd30aeaceaa"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "29f9397a8cee6ea519559666eca9fd4323259bc449543e8bc0f4afd30aeaceaa"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "29f9397a8cee6ea519559666eca9fd4323259bc449543e8bc0f4afd30aeaceaa"
    sha256 cellar: :any_skip_relocation, sonoma:         "532b4e68f1878d52077507f2ad662a5b6c86f410854a952f2269c1db2d34f778"
    sha256 cellar: :any_skip_relocation, ventura:        "532b4e68f1878d52077507f2ad662a5b6c86f410854a952f2269c1db2d34f778"
    sha256 cellar: :any_skip_relocation, monterey:       "532b4e68f1878d52077507f2ad662a5b6c86f410854a952f2269c1db2d34f778"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "29f9397a8cee6ea519559666eca9fd4323259bc449543e8bc0f4afd30aeaceaa"
  end

  depends_on "python@3.12"

  def install
    rewrite_shebang detected_python_shebang, "flawfinder.py"
    system "make", "prefix=#{prefix}", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      int demo(char *a, char *b) {
        strcpy(a, "\n");
        strcpy(a, gettext("Hello there"));
      }
    EOS
    assert_match("Hits = 2\n", shell_output("#{bin}/flawfinder test.c"))
  end
end
