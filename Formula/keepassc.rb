class Keepassc < Formula
  desc "Curses-based password manager for KeePass v.1.x and KeePassX"
  homepage "https://raymontag.github.com/keepassc/"
  url "https://files.pythonhosted.org/packages/c8/87/a7d40d4a884039e9c967fb2289aa2aefe7165110a425c4fb74ea758e9074/keepassc-1.8.2.tar.gz"
  sha256 "2e1fc6ccd5325c6f745f2d0a3bb2be26851b90d2095402dd1481a5c197a7b24e"
  revision 1

  bottle do
    cellar :any_skip_relocation
    sha256 "80422223a8d5011e6d2b94f76139ee2f6f5c5058380db593894f9122e8c0cc34" => :high_sierra
    sha256 "0a63a18a1f8468ba85f97bafe9f1ecca42faef5c31dfe8e0f0c5c821e7c387eb" => :sierra
    sha256 "b52b9a7089b4bbcc11d4acd0c30060614a3906363de95553699614ce5a7f8d73" => :el_capitan
  end

  depends_on "python"

  resource "kppy" do
    url "https://files.pythonhosted.org/packages/c8/d9/6ced04177b4790ccb1ba44e466c5b67f3a1cfe4152fb05ef5f990678f94f/kppy-1.5.2.tar.gz"
    sha256 "08fc48462541a891debe8254208fe162bcc1cd40aba3f4ca98286401faf65f28"
  end

  resource "pycryptodomex" do
    url "https://files.pythonhosted.org/packages/e6/5a/cf2bd33574f8f8711bad12baee7ef5c9c53a09c338cec241abfc0ba0cf63/pycryptodomex-3.6.3.tar.gz"
    sha256 "008ad82b8fdd1532dd32a0e0e4204af8e4710fc3d2a76e408cbdb3dddf4f8417"
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
    bin.env_script_all_files(libexec+"bin", :PYTHONPATH => ENV["PYTHONPATH"])
  end

  test do
    # Fetching help is the only non-interactive action we can perform, and since
    # interactive actions are un-scriptable, there nothing more we can do.
    system "#{bin}/keepassc", "--help"
  end
end
