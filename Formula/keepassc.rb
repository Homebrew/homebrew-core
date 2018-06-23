class Keepassc < Formula
  desc "Curses-based password manager for KeePass v.1.x and KeePassX"
  homepage "https://raymontag.github.com/keepassc/"
  url "https://files.pythonhosted.org/packages/ca/02/30e92fccd9b26f02782b36cffc4cb3a3ff824b23ad4a598b624958fe676e/keepassc-1.8.1.tar.gz"
  sha256 "9724a26cd4a32ac4587a26ea7d5406bbc48c9703617eba16772ab43c272d7c12"

  bottle do
    cellar :any_skip_relocation
    sha256 "c030cfcf3fdfef7addeed45b239dcfbbcaf13346d0020ebdf787611cabb6ce06" => :high_sierra
    sha256 "828d015d7b090d70b3792ac02c4479c681a9716067e497969a993b23ccd04221" => :sierra
    sha256 "1b1ababee30bca896679d79fc717605aa148ee6ccb7b0c28ec98992523686381" => :el_capitan
  end

  depends_on "python"

  resource "kppy" do
    url "https://files.pythonhosted.org/packages/c8/d9/6ced04177b4790ccb1ba44e466c5b67f3a1cfe4152fb05ef5f990678f94f/kppy-1.5.2.tar.gz"
    sha256 "08fc48462541a891debe8254208fe162bcc1cd40aba3f4ca98286401faf65f28"
  end

  resource "pycryptodomex" do
    url "https://files.pythonhosted.org/packages/6a/c4/21d55c2bf30995847406cb1a737d4ae5e19615eca39c9258f0548b5656f1/pycryptodomex-3.6.1.tar.gz"
    sha256 "82b758f870c8dd859f9b58bc9cff007403b68742f9e0376e2cbd8aa2ad3baa83"
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
