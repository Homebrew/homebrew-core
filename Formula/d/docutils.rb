class Docutils < Formula
  desc "Text processing system for reStructuredText"
  homepage "https://docutils.sourceforge.io"
  url "https://downloads.sourceforge.net/project/docutils/docutils/0.20.1/docutils-0.20.1.tar.gz"
  sha256 "f08a4e276c3a1583a86dce3e34aba3fe04d02bba2dd51ed16106244e8a923e3b"
  license all_of: [:public_domain, "BSD-2-Clause", "GPL-3.0-or-later", "Python-2.0"]
  revision 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "dd4ba2b284e5267446046167888360a4d3ee4879259d1a6d2c16a0c302373cc1"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9fe50df7baddc6b75851da3a9e8d68440bbcf21070e92e70a992b1684ba53574"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "12fdeaa68a7fbcbcf659679bbd34dcaf7eccfd5b1fce94f42c4d8f8e5f4a3d83"
    sha256 cellar: :any_skip_relocation, sonoma:         "666284171cef102f63b2f3d8ad4e6edc422279264311e02e6b4562cec74da111"
    sha256 cellar: :any_skip_relocation, ventura:        "18fa51222ab60c73986b5434796ea9a704d26d95b4d67cb41a984e90beb7a6f2"
    sha256 cellar: :any_skip_relocation, monterey:       "5f5e79f59567a89afa053c5f92bd694120965b24a3895ca787d649ac5c5777e7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "622a238e4cc5c6be5792bdbdd4f42b0c3f5052d3dbe928005183e48c6fec5b9e"
  end

  depends_on "python-setuptools" => :build
  depends_on "python@3.10" => [:build, :test]
  depends_on "python@3.11" => [:build, :test]
  depends_on "python@3.12" => [:build, :test]

  def pythons
    deps.map(&:to_formula)
        .select { |f| f.name.start_with?("python@") }
        .map { |f| f.opt_libexec/"bin/python" }
  end

  def install
    pythons.each do |python|
      system python, "-m", "pip", "install", *std_pip_args, "."
    end

    bin.glob("*.py") do |f|
      bin.install_symlink f => f.basename(".py")
    end
  end

  test do
    cp prefix/"README.txt", testpath
    mkdir_p testpath/"docs"
    touch testpath/"docs"/"header0.txt"
    system bin/"rst2man.py", testpath/"README.txt"
    system bin/"rst2man", testpath/"README.txt"
    pythons.each do |python|
      system python, "-c", "import docutils"
    end
  end
end
