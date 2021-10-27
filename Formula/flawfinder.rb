class Flawfinder < Formula
  include Language::Python::Shebang

  desc "Examines code and reports possible security weaknesses"
  homepage "https://dwheeler.com/flawfinder/"
  url "https://dwheeler.com/flawfinder/flawfinder-2.0.19.tar.gz"
  sha256 "fe550981d370abfa0a29671346cc0b038229a9bd90b239eab0f01f12212df618"
  license "GPL-2.0-or-later"
  revision 1
  head "https://github.com/david-a-wheeler/flawfinder.git"

  livecheck do
    url :homepage
    regex(/href=.*?flawfinder[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e1b43fa077ab243f046627e1bf10abeba91b90b58df58fa5e5c1427bf50e0719"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e1b43fa077ab243f046627e1bf10abeba91b90b58df58fa5e5c1427bf50e0719"
    sha256 cellar: :any_skip_relocation, monterey:       "b13d035b39d87e2f9ddfba4c8b03a3d676c8104b40fc882f2faf5473c7e91c78"
    sha256 cellar: :any_skip_relocation, big_sur:        "b13d035b39d87e2f9ddfba4c8b03a3d676c8104b40fc882f2faf5473c7e91c78"
    sha256 cellar: :any_skip_relocation, catalina:       "b13d035b39d87e2f9ddfba4c8b03a3d676c8104b40fc882f2faf5473c7e91c78"
    sha256 cellar: :any_skip_relocation, mojave:         "b13d035b39d87e2f9ddfba4c8b03a3d676c8104b40fc882f2faf5473c7e91c78"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e1b43fa077ab243f046627e1bf10abeba91b90b58df58fa5e5c1427bf50e0719"
  end

  depends_on "python@3.10"

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
