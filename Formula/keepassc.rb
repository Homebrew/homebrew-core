class Keepassc < Formula
  desc "Curses-based password manager for KeePass v.1.x and KeePassX"
  homepage "https://raymontag.github.com/keepassc/"
  url "https://github.com/raymontag/keepassc/archive/1.7.0.tar.gz"
  sha256 "218537f6a16f70d907d22a23d1a4dec952d7622c65fae65f03c9ee98e64938dd"
  revision 3
  head "https://github.com/raymontag/keepassc.git", :branch => "development"

  bottle do
    cellar :any_skip_relocation
    sha256 "3e96dcc537b012e1b6e4a8edd6857429e37b5909572c2d24d4394c440c7e6442" => :high_sierra
    sha256 "1b16b96c716ec9a9543f428c2e161216e0a6c832718e020f932c50190611f4e1" => :sierra
    sha256 "610a84c98419037a090438504be237dc3e25627ff6fc0f16e1e6bd642c618a0e" => :el_capitan
  end

  depends_on "python3"

  resource "pycrypto" do
    # homepage "https://www.dlitz.net/software/pycrypto"
    url "https://ftp.dlitz.net/pub/dlitz/crypto/pycrypto/pycrypto-2.6.1.tar.gz"
    sha256 "f2ce1e989b272cfcb677616763e0a2e7ec659effa67a88aa92b3a65528f60a3c"
  end

  resource "kppy" do
    # homepage "https://github.com/raymontag/kppy"
    url "https://github.com/raymontag/kppy/archive/1.4.0.tar.gz"
    sha256 "a7ebcb7a13b037aada2785ca19cbc1ecaf0351ffa422ca6b487ece0b09ce1c10"
  end

  def install
    pyver = Language::Python.major_minor_version "python3"
    ENV.prepend_create_path "PYTHONPATH", libexec+"lib/python#{pyver}/site-packages"
    install_args = %W[setup.py install --prefix=#{libexec}]

    resource("pycrypto").stage { system "python3", *install_args }
    resource("kppy").stage { system "python3", *install_args }

    system "python3", *install_args

    man1.install Dir["*.1"]

    bin.install Dir[libexec/"bin/*"]
    bin.env_script_all_files(libexec+"bin", :PYTHONPATH => ENV["PYTHONPATH"])
  end

  test do
    # Fetching help is the only non-interactive action we can perform, and since
    # interactive actions are un-scriptable, there nothing more we can do.
    system "#{bin}/keepassc", "--help"
  end
end
