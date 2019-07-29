class Keepassc < Formula
  desc "Curses-based password manager for KeePass v.1.x and KeePassX"
  homepage "https://raymontag.github.com/keepassc/"
  url "https://files.pythonhosted.org/packages/c8/87/a7d40d4a884039e9c967fb2289aa2aefe7165110a425c4fb74ea758e9074/keepassc-1.8.2.tar.gz"
  sha256 "2e1fc6ccd5325c6f745f2d0a3bb2be26851b90d2095402dd1481a5c197a7b24e"
  revision 1

  bottle do
    cellar :any_skip_relocation
    sha256 "af7729059e564b32a9e09947c2bcbcd439a198a10522983acc04fae72a0ed4dd" => :mojave
    sha256 "b963fd7217761500437a7a25e6e37a38cdd92da088de4a6de4b0d6e0184217fc" => :high_sierra
    sha256 "762071bc7437e9ecd1d6b036aedef31556da97bfd097560fd53c407e6d7cfc96" => :sierra
    sha256 "d476806614a7c45de1c6352e03b0d8a680700f6e97597efce1f927208136bf2e" => :el_capitan
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
