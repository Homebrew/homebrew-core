class Jrnl < Formula
  include Language::Python::Virtualenv

  desc "Command-line note taker"
  homepage "https://maebert.github.io/jrnl/"
  url "https://github.com/maebert/jrnl/archive/1.9.8.tar.gz"
  sha256 "ec9dcf01f67a2329218fcd090b56042379937b269ddbd8c0c64097636f012e63"
  revision 1

  bottle do
    cellar :any_skip_relocation
    sha256 "0405ac1f44fd61e06de216ac3e001b2c57c519ca4dec034ce2b40c32c2068017" => :mojave
    sha256 "88adaac30aa0138b9b3dadae0c60ff3638b519bf2731823d09237e8e282b6d2e" => :high_sierra
    sha256 "bbbe8f14dee56249781d5bea367ef17384a0b78b4c278b35bc9e2f2c3e2802a9" => :sierra
  end

  depends_on "python"

  resource "entrypoints" do
    url "https://files.pythonhosted.org/packages/27/e8/607697e6ab8a961fc0b141a97ea4ce72cd9c9e264adeb0669f6d194aa626/entrypoints-0.2.3.tar.gz"
    sha256 "d2d587dde06f99545fb13a383d2cd336a8ff1f359c5839ce3a64c917d10c029f"
  end

  resource "future" do
    url "https://files.pythonhosted.org/packages/00/2b/8d082ddfed935f3608cc61140df6dcbf0edea1bc3ab52fb6c29ae3e81e85/future-0.16.0.tar.gz"
    sha256 "e39ced1ab767b5936646cedba8bcce582398233d6a627067d4c6a454c90cfedb"
  end

  resource "keyring" do
    url "https://files.pythonhosted.org/packages/7c/c0/4f48b2b1ff9eec624624142e9be28a6c91b494fd1513df4ef7544da3886c/keyring-15.1.0.tar.gz"
    sha256 "6232b972dfbd44fd9bd649242dbf17f616988b152d4268f9ca1dcc704b467381"
  end

  resource "keyrings.alt" do
    url "https://files.pythonhosted.org/packages/3d/94/5953839c03457054707cc72466af7728c0588ca0398d7cab3af40c624393/keyrings.alt-3.1.tar.gz"
    sha256 "b59c86b67b9027a86e841a49efc41025bcc3b1b0308629617b66b7011e52db5a"
  end

  resource "parsedatetime" do
    url "https://files.pythonhosted.org/packages/e3/b3/02385db13f1f25f04ad7895f35e9fe3960a4b9d53112775a6f7d63f264b6/parsedatetime-2.4.tar.gz"
    sha256 "3d817c58fb9570d1eec1dd46fa9448cd644eeed4fb612684b02dfda3a79cb84b"
  end

  resource "pycrypto" do
    url "https://files.pythonhosted.org/packages/60/db/645aa9af249f059cc3a368b118de33889219e0362141e75d4eaf6f80f163/pycrypto-2.6.1.tar.gz"
    sha256 "f2ce1e989b272cfcb677616763e0a2e7ec659effa67a88aa92b3a65528f60a3c"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/a0/b0/a4e3241d2dee665fea11baec21389aec6886655cd4db7647ddf96c3fad15/python-dateutil-2.7.3.tar.gz"
    sha256 "e27001de32f627c22380a688bcc43ce83504a7bc5da472209b4c70f02829f0b8"
  end

  resource "pytz" do
    url "https://files.pythonhosted.org/packages/ca/a9/62f96decb1e309d6300ebe7eee9acfd7bccaeedd693794437005b9067b44/pytz-2018.5.tar.gz"
    sha256 "ffb9ef1de172603304d9d2819af6f5ece76f2e85ec10692a524dd876e72bf277"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/16/d8/bc6316cf98419719bd59c91742194c111b6f2e85abac88e496adefaf7afe/six-1.11.0.tar.gz"
    sha256 "70e8a77beed4562e7f14fe23a786b54f6296e34344c23bc42f07b15018ff98e9"
  end

  resource "tzlocal" do
    url "https://files.pythonhosted.org/packages/cb/89/e3687d3ed99bc882793f82634e9824e62499fdfdc4b1ae39e211c5b05017/tzlocal-1.5.1.tar.gz"
    sha256 "4ebeb848845ac898da6519b9b31879cf13b6626f7184c496037b818e238f2c4e"
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
