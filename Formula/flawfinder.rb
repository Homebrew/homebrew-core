class Flawfinder < Formula
  include Language::Python::Shebang

  desc "Examines code and reports possible security weaknesses"
  homepage "https://dwheeler.com/flawfinder/"
  url "https://dwheeler.com/flawfinder/flawfinder-2.0.17.tar.gz"
  sha256 "c28c1fff7657131c8f016c3309d0caeb58d367d61a5c4b56a26ac8314772d407"
  license "GPL-2.0-or-later"
  head "https://github.com/david-a-wheeler/flawfinder.git"

  livecheck do
    url :homepage
    regex(/href=.*?flawfinder[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "df22f7db861ca01a07b3591cd6169a56ea66ecd4e59b716ff9b0031973a1d489"
    sha256 cellar: :any_skip_relocation, big_sur:       "d84417a61a218f7a46d3658d6ce10eb1e6114e7964d8370e5a647677cc4c99a5"
    sha256 cellar: :any_skip_relocation, catalina:      "d84417a61a218f7a46d3658d6ce10eb1e6114e7964d8370e5a647677cc4c99a5"
    sha256 cellar: :any_skip_relocation, mojave:        "d84417a61a218f7a46d3658d6ce10eb1e6114e7964d8370e5a647677cc4c99a5"
  end

  depends_on "python@3.9"

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
