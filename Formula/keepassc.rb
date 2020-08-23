class Keepassc < Formula
  desc "Curses-based password manager for KeePass v.1.x and KeePassX"
  homepage "https://raymontag.github.com/keepassc/"
  url "https://files.pythonhosted.org/packages/c8/87/a7d40d4a884039e9c967fb2289aa2aefe7165110a425c4fb74ea758e9074/keepassc-1.8.2.tar.gz"
  sha256 "2e1fc6ccd5325c6f745f2d0a3bb2be26851b90d2095402dd1481a5c197a7b24e"
  license "ISC"
  revision 2

  bottle do
    cellar :any_skip_relocation
    sha256 "d45c0751c541f70f630d57b6de4be54c7e404fa447b00c645da081baecf4ef07" => :catalina
    sha256 "278b472373d6b75a37833a23a7bfe472c4bdd56ee582534a82a28b0a9dcd5248" => :mojave
    sha256 "6304afecfb788ee22bf327d47ca046fc905db8383b348393eb7907f7b1479ce4" => :high_sierra
  end

  depends_on "python@3.8"

  resource "kppy" do
    url "https://files.pythonhosted.org/packages/c8/d9/6ced04177b4790ccb1ba44e466c5b67f3a1cfe4152fb05ef5f990678f94f/kppy-1.5.2.tar.gz"
    sha256 "08fc48462541a891debe8254208fe162bcc1cd40aba3f4ca98286401faf65f28"
  end

  resource "pycryptodomex" do
    url "https://files.pythonhosted.org/packages/7f/3c/80cfaec41c3a9d0f524fe29bca9ab22d02ac84b5bfd6e22ade97d405bdba/pycryptodomex-3.9.7.tar.gz"
    sha256 "50163324834edd0c9ce3e4512ded3e221c969086e10fdd5d3fdcaadac5e24a78"
  end

  def install
    pyver = Language::Python.major_minor_version "python3"
    ENV.prepend_create_path "PYTHONPATH", libexec+"lib/python#{pyver}/site-packages"
    install_args = %W[setup.py install --prefix=#{libexec}]

    resource("pycryptodomex").stage { system "python3", *install_args }
    resource("kppy").stage { system "python3", *install_args }

    system "python3", *install_args

    man1.install Dir["*.1"]

    bin.install Dir[libexec/"bin/*"]
    bin.env_script_all_files(libexec+"bin", PYTHONPATH: ENV["PYTHONPATH"])
  end

  test do
    # Fetching help is the only non-interactive action we can perform, and since
    # interactive actions are un-scriptable, there nothing more we can do.
    system "#{bin}/keepassc", "--help"
  end
end
