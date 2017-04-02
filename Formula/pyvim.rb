class Pyvim < Formula
  desc "Pure Python Vim clone"
  homepage "https://pypi.python.org/pypi/pyvim"
  url "https://pypi.python.org/packages/f7/ae/21857aac8acb73f8f91aa50ba5319c5000257c5fa8ff13f29ce4698865f1/pyvim-0.0.18.tar.gz"
  sha256 "8a676fcb5bf78db5ad70c26131128f631f21556c4431f9a7fa6a5fdcdbb7e2e5"

  bottle do
    cellar :any_skip_relocation
    sha256 "a2a2f3d091eb0d197276646bc092a2317443527574cd015d3862526613c455ea" => :sierra
    sha256 "02b67a7b79ef341d0140de636ceabdddf8dee46212cdc303b0110fcbf5b08a4f" => :el_capitan
    sha256 "b88954d67cb3cc4663e58b835bba56d2827b84b71e239ef58c036aac7b0b5c12" => :yosemite
    sha256 "ff4daf14062aca74555c3d8e1a90bc464051c804300d7222e197b374ee196d2c" => :mavericks
  end

  depends_on :python if MacOS.version <= :snow_leopard

  resource "ptpython" do
    url "https://pypi.python.org/packages/39/cc/5cd0ff55d774fd287bf3f07fd5ed57c25117b68fa3d7fc7a9649d9b3a02d/ptpython-0.34.tar.gz"
    sha256 "23ccb0e9f28cfc8001b9db4cfd0193862e56f8e9c21425fea91059e0be8fabd6"
  end

  resource "prompt_toolkit" do
    url "https://pypi.python.org/packages/0b/2c/ab26db81e5b9c2f179a2e9d797f2ce0d11f7cc3308830831de0daad8629e/prompt_toolkit-1.0.0.tar.gz"
    sha256 "5108ed9e6e40d28cb1dc90ba563987859231289700d0def999007b08f4f74ea4"
  end

  resource "pyflakes" do
    url "https://pypi.python.org/packages/54/80/6a641f832eb6c6a8f7e151e7087aff7a7c04dd8b4aa6134817942cdda1b6/pyflakes-1.2.3.tar.gz"
    sha256 "2e4a1b636d8809d8f0a69f341acf15b2e401a3221ede11be439911d23ce2139e"
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
