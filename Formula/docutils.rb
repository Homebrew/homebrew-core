class Docutils < Formula
  include Language::Python::Virtualenv

  desc "Text processing system for reStructuredText"
  homepage "https://docutils.sourceforge.io"
  url "https://downloads.sourceforge.net/project/docutils/docutils/0.17.1/docutils-0.17.1.tar.gz"
  sha256 "686577d2e4c32380bb50cbb22f575ed742d58168cee37e99117a854bcd88f125"
  revision 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "b4f3eca7d4566cbb4ba7ecd31a55c6baf8bf3b6d3ff2574d0b91149e627a3b29"
    sha256 cellar: :any_skip_relocation, big_sur:       "526706f3668d3ea0cfdab76748a9de32835e4a2e901af6a85ecaee399c910503"
    sha256 cellar: :any_skip_relocation, catalina:      "526706f3668d3ea0cfdab76748a9de32835e4a2e901af6a85ecaee399c910503"
    sha256 cellar: :any_skip_relocation, mojave:        "526706f3668d3ea0cfdab76748a9de32835e4a2e901af6a85ecaee399c910503"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0317c9472b48cf0ce34c2d72dce67f4122579fec2f6e98c8caaf8b6942eb95e4"
  end

  depends_on "python@3.9"

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
