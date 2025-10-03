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

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 4
    sha256 cellar: :any_skip_relocation, all: "3d21cca878025689c10c24b55855c5cd035eb4dd0601707bc412eb17e97545ab"
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
