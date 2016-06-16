class Flake8 < Formula
  desc "Lint your Python code for style and logical errors"
  homepage "http://flake8.pycqa.org/"
  url "https://files.pythonhosted.org/packages/f4/c7/1c5bb63914354b2e4eb1d84634b96af8fad64278d84a30aa9bffbcf2e67d/flake8-2.6.0.tar.gz"
  sha256 "5ae018121a495edeb83097ba1bdd1a8481db24e1f0d54e8a78edb26ba0df82cf"

  head "https://gitlab.com/PyCQA/flake8.git", :shallow => false

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
