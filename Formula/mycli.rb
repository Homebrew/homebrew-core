class Mycli < Formula
  desc "CLI for MySQL with auto-completion and syntax highlighting"
  homepage "http://mycli.net/"
  url "https://pypi.python.org/packages/f8/8a/9f024656457cfb2afd19f93c3478f45c22a5599ebb24e04262a40d9171af/mycli-1.7.0.tar.gz"
  sha256 "f738d7f43f2c6420ed3da2410f06e8a1c58656a11a4b83d3557832c7f11b7b3d"

  bottle do
    cellar :any_skip_relocation
    sha256 "cb5c204df0f187845a6b0855e40328ed7917b478cfc65f89b3d8fcf9b8aaa27c" => :el_capitan
    sha256 "788cacc6752dd88e965d72aa3ce762dbbcfb7e81e73db8de1e18ba650140c709" => :yosemite
    sha256 "1173bdeba93190f076b6df5aa98601d94d15be537dd668dbf41dda87f8b793db" => :mavericks
  end

  depends_on :python if MacOS.version <= :snow_leopard
  depends_on "openssl"

  resource "click" do
    url "https://pypi.python.org/packages/source/c/click/click-6.6.tar.gz"
    sha256 "cc6a19da8ebff6e7074f731447ef7e112bd23adf3de5c597cf9989f2fd8defe9"
  end

  resource "configobj" do
    url "https://pypi.python.org/packages/source/c/configobj/configobj-5.0.6.tar.gz"
    sha256 "a2f5650770e1c87fb335af19a9b7eb73fc05ccf22144eb68db7d00cd2bcb0902"
  end

  resource "prompt_toolkit" do
    url "https://pypi.python.org/packages/0b/2c/ab26db81e5b9c2f179a2e9d797f2ce0d11f7cc3308830831de0daad8629e/prompt_toolkit-1.0.0.tar.gz"
    sha256 "5108ed9e6e40d28cb1dc90ba563987859231289700d0def999007b08f4f74ea4"
  end

  resource "pycrypto" do
    url "https://pypi.python.org/packages/source/p/pycrypto/pycrypto-2.6.1.tar.gz"
    sha256 "f2ce1e989b272cfcb677616763e0a2e7ec659effa67a88aa92b3a65528f60a3c"
  end

  resource "Pygments" do
    url "https://pypi.python.org/packages/source/P/Pygments/Pygments-2.1.3.tar.gz"
    sha256 "88e4c8a91b2af5962bfa5ea2447ec6dd357018e86e94c7d14bd8cacbc5b55d81"
  end

  resource "PyMySQL" do
    url "https://pypi.python.org/packages/source/P/PyMySQL/PyMySQL-0.7.2.tar.gz"
    sha256 "bd7acb4990dbf097fae3417641f93e25c690e01ed25c3ed32ea638d6c3ac04ba"
  end

  resource "six" do
    url "https://pypi.python.org/packages/source/s/six/six-1.10.0.tar.gz"
    sha256 "105f8d68616f8248e24bf0e9372ef04d3cc10104f1980f54d57b2ce73a5ad56a"
  end

  resource "sqlparse" do
    url "https://pypi.python.org/packages/source/s/sqlparse/sqlparse-0.1.19.tar.gz"
    sha256 "d896be1a1c7f24bffe08d7a64e6f0176b260e281c5f3685afe7826f8bada4ee8"
  end

  resource "wcwidth" do
    url "https://pypi.python.org/packages/source/w/wcwidth/wcwidth-0.1.6.tar.gz"
    sha256 "dcb3ec4771066cc15cf6aab5d5c4a499a5f01c677ff5aeb46cf20500dccd920b"
  end

  def install
    ENV.prepend_create_path "PYTHONPATH", libexec/"vendor/lib/python2.7/site-packages"
    %w[click prompt_toolkit pycrypto PyMySQL sqlparse Pygments wcwidth six configobj].each do |r|
      resource(r).stage do
        system "python", *Language::Python.setup_install_args(libexec/"vendor")
      end
    end

    ENV.prepend_create_path "PYTHONPATH", libexec/"lib/python2.7/site-packages"
    system "python", *Language::Python.setup_install_args(libexec)

    bin.install Dir["#{libexec}/bin/*"]
    bin.env_script_all_files(libexec/"bin", :PYTHONPATH => ENV["PYTHONPATH"])
  end

  test do
    system bin/"mycli", "--help"
  end
end
