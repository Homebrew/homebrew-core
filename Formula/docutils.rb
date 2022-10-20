class Docutils < Formula
  include Language::Python::Virtualenv

  desc "Text processing system for reStructuredText"
  homepage "https://docutils.sourceforge.io"
  url "https://downloads.sourceforge.net/project/docutils/docutils/0.19/docutils-0.19.tar.gz"
  sha256 "33995a6753c30b7f577febfc2c50411fec6aac7f7ffeb7c4cfe5991072dcf9e6"
  license all_of: [:public_domain, "BSD-2-Clause", "GPL-3.0-or-later", "Python-2.0"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b784e47113758f9c47cfa4567a26d862fc9d0921bd6b63565b093913f86607b4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b784e47113758f9c47cfa4567a26d862fc9d0921bd6b63565b093913f86607b4"
    sha256 cellar: :any_skip_relocation, monterey:       "ae5ef91d15f574fd9adeb50a5b1023c45f56fb7eed85ac270fdd0fcc401b41e3"
    sha256 cellar: :any_skip_relocation, big_sur:        "ae5ef91d15f574fd9adeb50a5b1023c45f56fb7eed85ac270fdd0fcc401b41e3"
    sha256 cellar: :any_skip_relocation, catalina:       "ae5ef91d15f574fd9adeb50a5b1023c45f56fb7eed85ac270fdd0fcc401b41e3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6a51a4a455f0f93c4020aa5c692df0cbee810a4967ca38708591cb91d584fe7c"
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
