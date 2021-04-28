class Docutils < Formula
  include Language::Python::Virtualenv

  desc "Text processing system for reStructuredText"
  homepage "https://docutils.sourceforge.io"
  url "https://downloads.sourceforge.net/project/docutils/docutils/0.17.1/docutils-0.17.1.tar.gz"
  sha256 "686577d2e4c32380bb50cbb22f575ed742d58168cee37e99117a854bcd88f125"
  revision 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "8c6f650a9ceec0e34b6d1463d40448e171027c230cfeba1d7bfa971c15d3ed0e"
    sha256 cellar: :any_skip_relocation, big_sur:       "97a939a036851c96bc4ac17d1a9fbf8bd8053f0c3c49402698963e32026985aa"
    sha256 cellar: :any_skip_relocation, catalina:      "97a939a036851c96bc4ac17d1a9fbf8bd8053f0c3c49402698963e32026985aa"
    sha256 cellar: :any_skip_relocation, mojave:        "954e70f84cb70b5e77478043ddf5784074015dfd11dbaf3e8906b83020e4a08b"
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
