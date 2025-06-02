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
    rebuild 3
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "030f54eb812b1a8db57bfabf283d62c211cc22c4690929288d3ff8e9cf17ad13"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "030f54eb812b1a8db57bfabf283d62c211cc22c4690929288d3ff8e9cf17ad13"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "030f54eb812b1a8db57bfabf283d62c211cc22c4690929288d3ff8e9cf17ad13"
    sha256 cellar: :any_skip_relocation, sonoma:        "3b696a9fc382e50b6306f43deb4b6a759d74acd32755573f7e0dc105794611e8"
    sha256 cellar: :any_skip_relocation, ventura:       "3b696a9fc382e50b6306f43deb4b6a759d74acd32755573f7e0dc105794611e8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "dbfca57b72d0516b9fcb37ebfc9aeb8af8b7550a4aa4b5e8562ae126261b9aa8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "030f54eb812b1a8db57bfabf283d62c211cc22c4690929288d3ff8e9cf17ad13"
  end

  depends_on "python@3.13"

  def install
    rewrite_shebang detected_python_shebang, "flawfinder.py"
    system "make", "prefix=#{prefix}", "install"
  end

  test do
    (testpath/"test.c").write <<~C
      int demo(char *a, char *b) {
        strcpy(a, "\n");
        strcpy(a, gettext("Hello there"));
      }
    C
    assert_match("Hits = 2\n", shell_output("#{bin}/flawfinder test.c"))
  end
end
