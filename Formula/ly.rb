class Ly < Formula
  include Language::Python::Virtualenv

  desc "Parse, manipulate or create documents in LilyPond format"
  homepage "https://github.com/frescobaldi/python-ly"
  url "https://files.pythonhosted.org/packages/9b/ed/e277509bb9f9376efe391f2f5a27da9840366d12a62bef30f44e5a24e0d9/python-ly-0.9.7.tar.gz"
  sha256 "d4d2b68eb0ef8073200154247cc9bd91ed7fb2671ac966ef3d2853281c15d7a8"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0dcf27a89d2609317d37fe547f8ef36a36da82a0f50ed89ece8484749e921027"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0dcf27a89d2609317d37fe547f8ef36a36da82a0f50ed89ece8484749e921027"
    sha256 cellar: :any_skip_relocation, monterey:       "fc74795dee4608e3081f648201d7de3178ae56893525b0ea1ad46fbfc055787c"
    sha256 cellar: :any_skip_relocation, big_sur:        "fc74795dee4608e3081f648201d7de3178ae56893525b0ea1ad46fbfc055787c"
    sha256 cellar: :any_skip_relocation, catalina:       "fc74795dee4608e3081f648201d7de3178ae56893525b0ea1ad46fbfc055787c"
    sha256 cellar: :any_skip_relocation, mojave:         "fc74795dee4608e3081f648201d7de3178ae56893525b0ea1ad46fbfc055787c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "07f31281d2b920050dc1a58c2b62ece43225fdbee9d4f0b3cf0a6bdc7a713ef2"
  end

  depends_on "python@3.10"

  def install
    virtualenv_install_with_resources
  end

  test do
    (testpath/"test.ly").write "\\relative { c' d e f g a b c }"
    output = shell_output "#{bin}/ly 'transpose c d' #{testpath}/test.ly"
    assert_equal "\\relative { d' e fis g a b cis d }", output
  end
end
