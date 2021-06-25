class Flawfinder < Formula
  include Language::Python::Shebang

  desc "Examines code and reports possible security weaknesses"
  homepage "https://dwheeler.com/flawfinder/"
  url "https://dwheeler.com/flawfinder/flawfinder-2.0.18.tar.gz"
  sha256 "6a51efd7869e0f36a00f33455ec2d1745dc36121130625887b4589e646f062c2"
  license "GPL-2.0-or-later"
  head "https://github.com/david-a-wheeler/flawfinder.git"

  livecheck do
    url :homepage
    regex(/href=.*?flawfinder[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "39f06571134ec3f510cceb1e460a9731619c7d1208a80e643a923be2041f80a9"
    sha256 cellar: :any_skip_relocation, big_sur:       "a4fde01595f0b99a964650333dc6d400f43bd26ab27f7a2cd27339bef8a1dce8"
    sha256 cellar: :any_skip_relocation, catalina:      "a4fde01595f0b99a964650333dc6d400f43bd26ab27f7a2cd27339bef8a1dce8"
    sha256 cellar: :any_skip_relocation, mojave:        "a4fde01595f0b99a964650333dc6d400f43bd26ab27f7a2cd27339bef8a1dce8"
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
