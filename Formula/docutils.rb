class Docutils < Formula
  include Language::Python::Virtualenv

  desc "Text processing system for reStructuredText"
  homepage "https://docutils.sourceforge.io"
  url "https://downloads.sourceforge.net/project/docutils/docutils/0.18.1/docutils-0.18.1.tar.gz"
  sha256 "679987caf361a7539d76e584cbeddc311e3aee937877c87346f31debc63e9d06"
  license all_of: [:public_domain, "BSD-2-Clause", "GPL-3.0-or-later", "Python-2.0"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d7be7131a30339be430d398e605bf870d1afa6842ece2f723b9ae4539f680c9c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d7be7131a30339be430d398e605bf870d1afa6842ece2f723b9ae4539f680c9c"
    sha256 cellar: :any_skip_relocation, monterey:       "b29fd5b105a8b42efb62815ddde41221d70aed081f2a0e8dd1f127da631a1b27"
    sha256 cellar: :any_skip_relocation, big_sur:        "b29fd5b105a8b42efb62815ddde41221d70aed081f2a0e8dd1f127da631a1b27"
    sha256 cellar: :any_skip_relocation, catalina:       "b29fd5b105a8b42efb62815ddde41221d70aed081f2a0e8dd1f127da631a1b27"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "204621df50ede7cc0c892dba0f23923945ef919eb0eb87b62f46963bf4a00c99"
  end

  depends_on "python@3.10"

  def install
    virtualenv_install_with_resources

    Dir.glob("#{libexec}/bin/*.py") do |f|
      bin.install_symlink f => File.basename(f, ".py")
    end
  end

  test do
    system "#{bin}/rst2man.py", "#{prefix}/HISTORY.txt"
  end
end
