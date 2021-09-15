class Flawfinder < Formula
  include Language::Python::Shebang

  desc "Examines code and reports possible security weaknesses"
  homepage "https://dwheeler.com/flawfinder/"
  url "https://dwheeler.com/flawfinder/flawfinder-2.0.19.tar.gz"
  sha256 "fe550981d370abfa0a29671346cc0b038229a9bd90b239eab0f01f12212df618"
  license "GPL-2.0-or-later"
  head "https://github.com/david-a-wheeler/flawfinder.git"

  livecheck do
    url :homepage
    regex(/href=.*?flawfinder[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "4d66b65f5681f260ed454465b9b5176d3325e971f8092a1275776c80515d76be"
    sha256 cellar: :any_skip_relocation, big_sur:       "407c52c1becc39385244c0d877570de07e10daeab69001c675299c16c81e1ea1"
    sha256 cellar: :any_skip_relocation, catalina:      "407c52c1becc39385244c0d877570de07e10daeab69001c675299c16c81e1ea1"
    sha256 cellar: :any_skip_relocation, mojave:        "407c52c1becc39385244c0d877570de07e10daeab69001c675299c16c81e1ea1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4d66b65f5681f260ed454465b9b5176d3325e971f8092a1275776c80515d76be"
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
