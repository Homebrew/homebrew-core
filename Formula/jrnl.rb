class Jrnl < Formula
  include Language::Python::Virtualenv
  desc "Command-line note taker"
  homepage "https://maebert.github.io/jrnl/"
  url "https://github.com/maebert/jrnl/archive/1.9.8.tar.gz"
  sha256 "ec9dcf01f67a2329218fcd090b56042379937b269ddbd8c0c64097636f012e63"

  bottle do
    cellar :any_skip_relocation
    sha256 "fae247f2ebb1f66243fcbb4c8912075adc019928f6cb45651abf5fe3b159d877" => :high_sierra
    sha256 "ecd709c46c9bb70293fdec35d5024eb018682293dad29fc66a604cc649d5c0bf" => :sierra
    sha256 "f29a67273bdd14e87e93ff3062a81e8e946aada52acbb61f9e1b75e372fabc00" => :el_capitan
    sha256 "9e44aeb99a2923c3c7b00619f85c30d6d160289dfe43901c2e4df46d914009db" => :yosemite
  end

  depends_on "python" if MacOS.version <= :snow_leopard

  resource "future" do
    url "https://files.pythonhosted.org/packages/00/2b/8d082ddfed935f3608cc61140df6dcbf0edea1bc3ab52fb6c29ae3e81e85/future-0.16.0.tar.gz"
    sha256 "e39ced1ab767b5936646cedba8bcce582398233d6a627067d4c6a454c90cfedb"
  end

  resource "keyring" do
    url "https://files.pythonhosted.org/packages/d2/2f/b70bf3068b5964e4c45507e03652da0743c72460ff929e70aef201ed5ffb/keyring-10.3.tar.gz"
    sha256 "220a92af8119eb38e7f9afbdf8c2c93eef8186cc39e9ab2a0e4c80807df00e45"
  end

  resource "keyrings.alt" do
    url "https://files.pythonhosted.org/packages/de/e7/b9ea280aa9a42234c0e08e2faa738542f08aff9e57036d68493460202d09/keyrings.alt-2.0.tar.gz"
    sha256 "12a01731963810ab647f7cc3ea3070c7924f9a28a88d8dc0c53e119ba9a83122"
  end

  resource "parsedatetime" do
    url "https://files.pythonhosted.org/packages/62/a3/0c546deec0c1ea5e20320daf7719df9419c2bee97f1a11b9feaf0143b0fc/parsedatetime-2.2.tar.gz"
    sha256 "1b1b647812e336f85be84206e4fb1f2df3852e036ac35b18dec809e7ebff1309"
  end

  resource "pycrypto" do
    url "https://files.pythonhosted.org/packages/60/db/645aa9af249f059cc3a368b118de33889219e0362141e75d4eaf6f80f163/pycrypto-2.6.1.tar.gz"
    sha256 "f2ce1e989b272cfcb677616763e0a2e7ec659effa67a88aa92b3a65528f60a3c"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/b4/7c/df59c89a753eb33c7c44e1dd42de0e9bc2ccdd5a4d576e0bfad97cc280cb/python-dateutil-1.5.tar.gz"
    sha256 "6f197348b46fb8cdf9f3fcfc2a7d5a97da95db3e2e8667cf657216274fe1b009"
  end

  resource "pytz" do
    url "https://files.pythonhosted.org/packages/d0/e1/aca6ef73a7bd322a7fc73fd99631ee3454d4fc67dc2bee463e2adf6bb3d3/pytz-2016.10.tar.bz2"
    sha256 "7016b2c4fa075c564b81c37a252a5fccf60d8964aa31b7f5eae59aeb594ae02b"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/b3/b2/238e2590826bfdd113244a40d9d3eb26918bd798fc187e2360a8367068db/six-1.10.0.tar.gz"
    sha256 "105f8d68616f8248e24bf0e9372ef04d3cc10104f1980f54d57b2ce73a5ad56a"
  end

  resource "tzlocal" do
    url "https://files.pythonhosted.org/packages/d3/64/e4b18738496213f82b88b31c431a0e4ece143801fb6771dddd1c2bf0101b/tzlocal-1.3.tar.gz"
    sha256 "d160c2ce4f8b1831dabfe766bd844cf9012f766539cf84139c2faac5201882ce"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    (testpath/"write_journal.sh").write <<~EOS
      #!/usr/bin/expect -f
      set timeout -1
      spawn #{bin}/jrnl today: Wrote this fancy test.
      expect -exact "Path to your journal file (leave blank for ~/journal.txt):"
      send -- "#{testpath}/journal\n"
      expect -exact "Enter password for journal (leave blank for no encryption): "
      send -- "Homebrew\n"
      expect "Do you want to store the password in your keychain?"
      send -- "N\n"
      expect -exact "Journal will be encrypted."
      expect "Entry added to default journal"
      expect eof
    EOS
    chmod 0755, testpath/"write_journal.sh"

    system "./write_journal.sh"
    assert_predicate testpath/"journal", :exist?
    assert_predicate testpath/".jrnl_config", :exist?
  end
end
