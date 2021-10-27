class Keepassc < Formula
  desc "Curses-based password manager for KeePass v.1.x and KeePassX"
  homepage "https://github.com/raymontag/keepassc"
  url "https://files.pythonhosted.org/packages/c8/87/a7d40d4a884039e9c967fb2289aa2aefe7165110a425c4fb74ea758e9074/keepassc-1.8.2.tar.gz"
  sha256 "2e1fc6ccd5325c6f745f2d0a3bb2be26851b90d2095402dd1481a5c197a7b24e"
  license "ISC"
  revision 4

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8556297abd34b591ddb4d93ada1059039f78927bec4858f5ad8ced245e9083ea"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c84dd256b4392893dc1b756f16486f8c98ba6f6fbffdfb2573100b4bfd3efbc1"
    sha256 cellar: :any_skip_relocation, monterey:       "b25905da9514361ee40ea00e8e027bcb07aaeadab8bda8fcd37c595af909decb"
    sha256 cellar: :any_skip_relocation, big_sur:        "e1cf6e43638026d1deaa3e90e07ff03dec482e6f8fb19be895309c9be2a9abe9"
    sha256 cellar: :any_skip_relocation, catalina:       "c3b6090b7cb27dfcbd563b152bac02444979535a97aa422f3458bd701246c0eb"
    sha256 cellar: :any_skip_relocation, mojave:         "512d04b7df021f0a3a29dad0a2efc0262483a4cfe3e9385938afa346f73ac92e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fee5bf5f8161aa727c06397811e1d7a2910dfefbffbf8fcb2cad0ec5cc55ac15"
  end

  depends_on "python@3.10"

  resource "kppy" do
    url "https://files.pythonhosted.org/packages/c8/d9/6ced04177b4790ccb1ba44e466c5b67f3a1cfe4152fb05ef5f990678f94f/kppy-1.5.2.tar.gz"
    sha256 "08fc48462541a891debe8254208fe162bcc1cd40aba3f4ca98286401faf65f28"
  end

  resource "pycryptodomex" do
    url "https://files.pythonhosted.org/packages/14/90/f4a934bffae029e16fb33f3bd87014a0a18b4bec591249c4fc01a18d3ab6/pycryptodomex-3.9.9.tar.gz"
    sha256 "7b5b7c5896f8172ea0beb283f7f9428e0ab88ec248ce0a5b8c98d73e26267d51"
  end

  def install
    pyver = Language::Python.major_minor_version "python3"
    ENV.prepend_create_path "PYTHONPATH", libexec/"lib/python#{pyver}/site-packages"
    install_args = %W[setup.py install --prefix=#{libexec}]

    resource("pycryptodomex").stage do
      system "python3", *install_args, "--single-version-externally-managed", "--record=installed.txt"
    end

    resource("kppy").stage do
      system "python3", *install_args
    end

    system "python3", *install_args

    man1.install Dir["*.1"]

    bin.install Dir[libexec/"bin/*"]
    bin.env_script_all_files libexec/"bin", PYTHONPATH: ENV["PYTHONPATH"]
  end

  test do
    # Fetching help is the only non-interactive action we can perform, and since
    # interactive actions are un-scriptable, there nothing more we can do.
    system bin/"keepassc", "--help"
  end
end
