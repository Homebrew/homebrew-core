class Keepassc < Formula
  desc "Curses-based password manager for KeePass v.1.x and KeePassX"
  homepage "https://raymontag.github.com/keepassc/"
  url "https://github.com/raymontag/keepassc/archive/1.7.0.tar.gz"
  sha256 "218537f6a16f70d907d22a23d1a4dec952d7622c65fae65f03c9ee98e64938dd"
  revision 3
  head "https://github.com/raymontag/keepassc.git", :branch => "development"

  bottle do
    cellar :any_skip_relocation
    sha256 "ac204754eed42b14e5f72339c819fa70a2c28965af964950071183eba92c54dd" => :high_sierra
    sha256 "1e99f95e24602a4f7dd83a970cae3443007ad2c7809d05b1b465c679b87b0d13" => :sierra
    sha256 "c185668f790114959248ac59e8f69e40624e68bfae512e38e6021a4bd1f55d21" => :el_capitan
    sha256 "656de743c74e27801eb05c1c8639cc19fe174b2aace6dd503358c60ed9125c85" => :yosemite
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
