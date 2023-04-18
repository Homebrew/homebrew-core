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
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "baa4ede546ed9ce3bc3283002cde1fb529a6c91030614df0a5e30adadf38b933"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "baa4ede546ed9ce3bc3283002cde1fb529a6c91030614df0a5e30adadf38b933"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "baa4ede546ed9ce3bc3283002cde1fb529a6c91030614df0a5e30adadf38b933"
    sha256 cellar: :any_skip_relocation, ventura:        "914cd86fc8a41d17755bd041e7f57233d09d591257dba66ee2b166ebeed49e70"
    sha256 cellar: :any_skip_relocation, monterey:       "914cd86fc8a41d17755bd041e7f57233d09d591257dba66ee2b166ebeed49e70"
    sha256 cellar: :any_skip_relocation, big_sur:        "914cd86fc8a41d17755bd041e7f57233d09d591257dba66ee2b166ebeed49e70"
    sha256 cellar: :any_skip_relocation, catalina:       "914cd86fc8a41d17755bd041e7f57233d09d591257dba66ee2b166ebeed49e70"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "baa4ede546ed9ce3bc3283002cde1fb529a6c91030614df0a5e30adadf38b933"
  end

  depends_on "python@3.11"

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
