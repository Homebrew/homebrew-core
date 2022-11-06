class Ly < Formula
  include Language::Python::Virtualenv

  desc "Parse, manipulate or create documents in LilyPond format"
  homepage "https://github.com/frescobaldi/python-ly"
  url "https://files.pythonhosted.org/packages/9b/ed/e277509bb9f9376efe391f2f5a27da9840366d12a62bef30f44e5a24e0d9/python-ly-0.9.7.tar.gz"
  sha256 "d4d2b68eb0ef8073200154247cc9bd91ed7fb2671ac966ef3d2853281c15d7a8"
  license "GPL-2.0-or-later"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3f1eaf6bfbb547929c088d639f9c3f861eea96c6f511a299e594a8e5e3940313"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3f1eaf6bfbb547929c088d639f9c3f861eea96c6f511a299e594a8e5e3940313"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3f1eaf6bfbb547929c088d639f9c3f861eea96c6f511a299e594a8e5e3940313"
    sha256 cellar: :any_skip_relocation, monterey:       "faf91829a1e7d98be8186d0dd8bd980e436e7f489532460cf5ec95d452c23424"
    sha256 cellar: :any_skip_relocation, big_sur:        "faf91829a1e7d98be8186d0dd8bd980e436e7f489532460cf5ec95d452c23424"
    sha256 cellar: :any_skip_relocation, catalina:       "faf91829a1e7d98be8186d0dd8bd980e436e7f489532460cf5ec95d452c23424"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "730d66f95185949aab835d751c6ce5658bb20b9b4819f8d61931c28d7a9fa2b3"
  end

  depends_on "python@3.11"

  def install
    virtualenv_install_with_resources
  end

  test do
    (testpath/"test.ly").write "\\relative { c' d e f g a b c }"
    output = shell_output "#{bin}/ly 'transpose c d' #{testpath}/test.ly"
    assert_equal "\\relative { d' e fis g a b cis d }", output
  end
end
