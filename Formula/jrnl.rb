class Jrnl < Formula
  desc "Command-line note taker"
  homepage "https://maebert.github.io/jrnl/"
  url "https://github.com/maebert/jrnl/archive/1.9.7.tar.gz"
  sha256 "789de4bffe0c22911a4968e525feeb20a6c7c4f4fe762a936ce2dac2213cd855"

  bottle do
    cellar :any_skip_relocation
    sha256 "b5f24dc1ba2c58e7a9cebd7ae0492be6fbab0c05c3fa96e2f7cf9f9e9513bfd5" => :el_capitan
    sha256 "0b3c9aa68cb0030d466a7791bf20efba2969ba1884f04a96c51503f2e13fb62b" => :yosemite
    sha256 "85b7ad5b70623523729e5211581e5fc3b096b6dff8d6828781df4133f6b9a545" => :mavericks
    sha256 "b4e68781cff4b60490c309a26e66b60860dd0b3b87e580e8d93c0930cd5481c7" => :mountain_lion
  end

  depends_on :python if MacOS.version <= :snow_leopard

  resource "pycrypto" do
    url "https://files.pythonhosted.org/packages/60/db/645aa9af249f059cc3a368b118de33889219e0362141e75d4eaf6f80f163/pycrypto-2.6.1.tar.gz"
    sha256 "f2ce1e989b272cfcb677616763e0a2e7ec659effa67a88aa92b3a65528f60a3c"
  end

  resource "keyring" do
    url "https://files.pythonhosted.org/packages/ff/58/f3393b41852c1a1b12a9fcdfb468f638d0808c3520f23cc7c13f8f6c14e0/keyring-9.3.tar.gz"
    sha256 "5c6cc42902c2135e4cb674b9108fc7a9ddb9550466dc332640ca89034984f7c2"
  end

  resource "parsedatetime" do
    url "https://files.pythonhosted.org/packages/8b/20/37822d52be72c99cad913fad0b992d982928cac882efbbc491d4b9d216a9/parsedatetime-2.1.tar.gz"
    sha256 "17c578775520c99131634e09cfca5a05ea9e1bd2a05cd06967ebece10df7af2d"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/b4/7c/df59c89a753eb33c7c44e1dd42de0e9bc2ccdd5a4d576e0bfad97cc280cb/python-dateutil-1.5.tar.gz"
    sha256 "6f197348b46fb8cdf9f3fcfc2a7d5a97da95db3e2e8667cf657216274fe1b009"
  end

  resource "pytz" do
    url "https://files.pythonhosted.org/packages/f4/7d/7c0c85e9c64a75dde11bc9d3e1adc4e09a42ce7cdb873baffa1598118709/pytz-2016.4.tar.bz2"
    sha256 "ee7c751544e35a7b7fb5e3fb25a49dade37d51e70a93e5107f10575d7102c311"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/b3/b2/238e2590826bfdd113244a40d9d3eb26918bd798fc187e2360a8367068db/six-1.10.0.tar.gz"
    sha256 "105f8d68616f8248e24bf0e9372ef04d3cc10104f1980f54d57b2ce73a5ad56a"
  end

  resource "tzlocal" do
    url "https://files.pythonhosted.org/packages/a0/41/c722d033d62f1b3aa01ed55b9ca03d049e72bba1c08c60150a327ba80add/tzlocal-1.2.2.tar.gz"
    sha256 "cbbaa4e9d25c36386f12af9febe315139fdd39317b91abcb42d782a5e93e525d"
  end

  def install
    ENV.prepend_create_path "PYTHONPATH", libexec/"vendor/lib/python2.7/site-packages"
    %w[six pycrypto keyring parsedatetime python-dateutil pytz tzlocal].each do |r|
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
    system "#{bin}/jrnl", "-v"
  end
end
