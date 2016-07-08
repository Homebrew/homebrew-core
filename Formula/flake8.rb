class Flake8 < Formula
  desc "Lint your Python code for style and logical errors"
  homepage "http://flake8.pycqa.org/"
  url "https://files.pythonhosted.org/packages/53/0a/b2c28a77dfc508ed9f7334252311e1aaf8f0ceaaeb1a8f15fa4ba3e2d847/flake8-2.6.2.tar.gz"
  sha256 "231cd86194aaec4bdfaa553ae1a1cd9b7b4558332fbc10136c044940d587a778"

  head "https://gitlab.com/PyCQA/flake8.git", :shallow => false

  bottle do
    cellar :any_skip_relocation
    sha256 "ecc00e80619b707e66e1aac7ff532cc5afb320bd3dd5b6a79fe0b81732b40af9" => :el_capitan
    sha256 "2e94ceb04e9d4f7f30be54ed19ab77ff37e0cee8e0f5f4ef6f8b6b3a5d42ee0a" => :yosemite
    sha256 "934624221cd86a99e4b04cc1c6a8b15e4ff1f1d6101ce39d2341e21bd7374036" => :mavericks
  end

  depends_on :python if MacOS.version <= :snow_leopard

  resource "pycodestyle" do
    url "https://files.pythonhosted.org/packages/db/b1/9f798e745a4602ab40bf6a9174e1409dcdde6928cf800d3aab96a65b1bbf/pycodestyle-2.0.0.tar.gz"
    sha256 "37f0420b14630b0eaaf452978f3a6ea4816d787c3e6dcbba6fb255030adae2e7"
  end

  resource "pyflakes" do
    url "https://files.pythonhosted.org/packages/54/80/6a641f832eb6c6a8f7e151e7087aff7a7c04dd8b4aa6134817942cdda1b6/pyflakes-1.2.3.tar.gz"
    sha256 "2e4a1b636d8809d8f0a69f341acf15b2e401a3221ede11be439911d23ce2139e"
  end

  resource "mccabe" do
    url "https://files.pythonhosted.org/packages/57/fa/4a0cda4cf9877d2bd12ab031ae4ecfdc5c1bbb6e68f3fe80da4f29947c2a/mccabe-0.5.0.tar.gz"
    sha256 "379358498f58f69157b53f59f46aefda0e9a3eb81365238f69fbedf7014e21ab"
  end

  def install
    ENV.prepend_create_path "PYTHONPATH", "#{libexec}/vendor/lib/python2.7/site-packages"

    %w[pycodestyle pyflakes mccabe].each do |dependency|
      resource(dependency).stage do
        system "python", *Language::Python.setup_install_args(libexec/"vendor")
      end
    end

    ENV.prepend_create_path "PYTHONPATH", "#{libexec}/lib/python2.7/site-packages"
    system "python", *Language::Python.setup_install_args(libexec)

    bin.install Dir[libexec/"bin/*"]
    bin.env_script_all_files(libexec/"bin", :PYTHONPATH => ENV["PYTHONPATH"])
  end

  test do
    system "#{bin}/flake8", "#{libexec}/lib/python2.7/site-packages/flake8"
  end
end
