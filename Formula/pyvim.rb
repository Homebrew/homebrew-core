class Pyvim < Formula
  desc "Pure Python Vim clone"
  homepage "https://pypi.python.org/pypi/pyvim"
  url "https://pypi.python.org/packages/b0/0b/a68957e643c184c7b395ac3c336daa75f43c484ea3dee67387bbc3ecaf8f/pyvim-0.0.17.tar.gz"
  sha256 "e2e9495b13b00dc0d358002bf3665bb80029e90645bc2150f8b534c2da138e28"

  bottle do
    cellar :any_skip_relocation
    sha256 "5e73f934e89da7871b0fd645dcf75ae6cb2f3e7eba0326ad80de39a8e442a28a" => :el_capitan
    sha256 "514e9c6314fe574df2306a80a4eaf7227136de74419d2edae735acd5039ea39f" => :yosemite
    sha256 "05555d583b3aacb1e5f52273faf5f819f4087076896076ce28e572607467f070" => :mavericks
  end

  depends_on :python if MacOS.version <= :snow_leopard

  resource "ptpython" do
    url "https://pypi.python.org/packages/46/68/aeff7b6e1ed9e519eb2ef11fa78cc73e04a27b08f69f3c8ea23fc30736d4/ptpython-0.33.tar.gz"
    sha256 "86bb8bc6b3b2e4c7d4b400867d53fd94ffc4fe029d146f7a54d4e53160479435"
  end

  resource "prompt_toolkit" do
    url "https://pypi.python.org/packages/0b/2c/ab26db81e5b9c2f179a2e9d797f2ce0d11f7cc3308830831de0daad8629e/prompt_toolkit-1.0.0.tar.gz"
    sha256 "5108ed9e6e40d28cb1dc90ba563987859231289700d0def999007b08f4f74ea4"
  end

  resource "pyflakes" do
    url "https://pypi.python.org/packages/af/6e/6f8cb1d6dfb08b08c2f4c11fdb478b8d63f51f03d1d1bd61d4e154922cc2/pyflakes-1.2.2.tar.gz"
    sha256 "58741f9d3bffeba8f88452c1eddcf1b3eee464560e4589e4b81de8b3c9e42e4d"
  end

  resource "docopt" do
    url "https://pypi.python.org/packages/source/d/docopt/docopt-0.6.2.tar.gz"
    sha256 "49b3a825280bd66b3aa83585ef59c4a8c82f2c8a522dbe754a8bc8d08c85c491"
  end

  resource "jedi" do
    url "https://pypi.python.org/packages/source/j/jedi/jedi-0.9.0.tar.gz"
    sha256 "3b4c19fba31bdead9ab7350fb9fa7c914c59b0a807dcdd5c00a05feb85491d31"
  end

  resource "wcwidth" do
    url "https://pypi.python.org/packages/source/w/wcwidth/wcwidth-0.1.6.tar.gz"
    sha256 "dcb3ec4771066cc15cf6aab5d5c4a499a5f01c677ff5aeb46cf20500dccd920b"
  end

  resource "pygments" do
    url "https://pypi.python.org/packages/source/P/Pygments/Pygments-2.1.3.tar.gz"
    sha256 "88e4c8a91b2af5962bfa5ea2447ec6dd357018e86e94c7d14bd8cacbc5b55d81"
  end

  resource "six" do
    url "https://pypi.python.org/packages/source/s/six/six-1.10.0.tar.gz"
    sha256 "105f8d68616f8248e24bf0e9372ef04d3cc10104f1980f54d57b2ce73a5ad56a"
  end

  def install
    resources.each do |r|
      r.stage do
        system "python", *Language::Python.setup_install_args(libexec)
      end
    end

    ENV.prepend_create_path "PYTHONPATH", libexec/"lib/python2.7/site-packages"
    system "python", *Language::Python.setup_install_args(libexec)
    bin.install Dir[libexec/"bin/*"]
    bin.env_script_all_files(libexec/"bin", :PYTHONPATH => ENV["PYTHONPATH"])
  end

  test do
    system "#{bin}/pyvim", "--help"
  end
end
