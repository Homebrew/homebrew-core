class DcosCli < Formula
  include Language::Python::Virtualenv

  desc "Cross-platform command-line utility to manage DC/OS clusters"
  homepage "https://dcos.io/docs/1.9/cli/"
  url "https://github.com/dcos/dcos-cli/archive/0.5.1.tar.gz"
  sha256 "5dbf129acc9662ada5eb71024e80f04c44f97b13697dc44a5670eaac148d3222"
  head "git@github.com:dcos/dcos-cli.git"

  depends_on :python3
  depends_on "openssl@1.1"

  resource "appdirs" do
    url "https://files.pythonhosted.org/packages/48/69/d87c60746b393309ca30761f8e2b49473d43450b150cb08f3c6df5c11be5/appdirs-1.4.3.tar.gz"
    sha256 "9e5896d1372858f8dd3344faf4e5014d21849c756c8d5701f78f8a103b372d92"
  end

  resource "cffi" do
    url "https://files.pythonhosted.org/packages/5b/b9/790f8eafcdab455bcd3bd908161f802c9ce5adbf702a83aa7712fcc345b7/cffi-1.10.0.tar.gz"
    sha256 "b3b02911eb1f6ada203b0763ba924234629b51586f72a21faacc638269f4ced5"
  end

  resource "cryptography" do
    url "https://files.pythonhosted.org/packages/d7/a2/b90736c37fd720db425c5e48d69da75a6eff6609b22d2123762f1ae8c5f5/cryptography-1.6.tar.gz"
    sha256 "4d0d86d2c8d3fc89133c3fa0d164a688a458b6663ab6fa965c80d6c2cdaf9b3f"
  end

  resource "docopt" do
    url "https://files.pythonhosted.org/packages/a2/55/8f8cab2afd404cf578136ef2cc5dfb50baa1761b68c9da1fb1e4eed343c9/docopt-0.6.2.tar.gz"
    sha256 "49b3a825280bd66b3aa83585ef59c4a8c82f2c8a522dbe754a8bc8d08c85c491"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/d8/82/28a51052215014efc07feac7330ed758702fc0581347098a81699b5281cb/idna-2.5.tar.gz"
    sha256 "3cb5ce08046c4e3a560fc02f138d0ac63e00f8ce5901a56b32ec8b7994082aab"
  end

  resource "jsonschema" do
    url "https://files.pythonhosted.org/packages/58/b9/171dbb07e18c6346090a37f03c7e74410a1a56123f847efed59af260a298/jsonschema-2.6.0.tar.gz"
    sha256 "6ff5f3180870836cae40f06fa10419f557208175f13ad7bc26caa77beb1f6e02"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/c6/70/bb32913de251017e266c5114d0a645f262fb10ebc9bf6de894966d124e35/packaging-16.8.tar.gz"
    sha256 "5d50835fdf0a7edf0b55e311b7c887786504efea1177abd7e69329a8e5ea619e"
  end

  resource "pager" do
    url "https://files.pythonhosted.org/packages/5f/a1/95f8605e50c0ccc85ae53f63f5c4cb83b72f71fbd049a0e8259913e2cc22/pager-3.3.tar.gz"
    sha256 "18aa45ec877dca732e599531c7b3b0b22ed6a4445febdf1bdf7da2761cca340d"
  end

  resource "pkginfo" do
    url "https://files.pythonhosted.org/packages/a9/52/f6f41c68625a79bc037d8d75b5a5aa5f525ce2831152be81b5fdb5150175/pkginfo-1.2.1.tar.gz"
    sha256 "ad3f6dfe8a831f96a7b56a588ca874137ca102cc6b79fc9b0a1c3b7ab7320f3c"
  end

  resource "PrettyTable" do
    url "https://files.pythonhosted.org/packages/ef/30/4b0746848746ed5941f052479e7c23d2b56d174b82f4fd34a25e389831f5/prettytable-0.7.2.tar.bz2"
    sha256 "853c116513625c738dc3ce1aee148b5b5757a86727e67eff6502c7ca59d43c36"
  end

  resource "pyasn1" do
    url "https://files.pythonhosted.org/packages/69/17/eec927b7604d2663fef82204578a0056e11e0fc08d485fdb3b6199d9b590/pyasn1-0.2.3.tar.gz"
    sha256 "738c4ebd88a718e700ee35c8d129acce2286542daa80a82823a7073644f706ad"
  end

  resource "pycparser" do
    url "https://files.pythonhosted.org/packages/be/64/1bb257ffb17d01f4a38d7ce686809a736837ad4371bcc5c42ba7a715c3ac/pycparser-2.17.tar.gz"
    sha256 "0aac31e917c24cb3357f5a4d5566f2cc91a19ca41862f6c3c22dc60a629673b6"
  end

  resource "Pygments" do
    url "https://files.pythonhosted.org/packages/71/2a/2e4e77803a8bd6408a2903340ac498cb0a2181811af7c9ec92cb70b0308a/Pygments-2.2.0.tar.gz"
    sha256 "dbae1046def0efb574852fab9e90209b23f556367b5a320c0bcb871c77c3e8cc"
  end

  resource "PyJWT" do
    url "https://files.pythonhosted.org/packages/8f/10/9ce7e91d8ec9d852db6f9f2b076811d9f51ed7b0360602432d95e6ea4feb/PyJWT-1.4.2.tar.gz"
    sha256 "87a831b7a3bfa8351511961469ed0462a769724d4da48a501cb8c96d1e17f570"
  end

  resource "pyparsing" do
    url "https://files.pythonhosted.org/packages/3c/ec/a94f8cf7274ea60b5413df054f82a8980523efd712ec55a59e7c3357cf7c/pyparsing-2.2.0.tar.gz"
    sha256 "0832bcf47acd283788593e7a0f542407bd9550a55a8a8435214a1960e04bcb04"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/8c/ff/78297074b9b4cf102f9bbd71b62508965dd5c1876e016ef131e5b15c16a4/requests-2.14.1.tar.gz"
    sha256 "b3b191d677e526c1e512db86bc7387ccb8356e8826bcc7faa07f78f09afe68dd"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/b3/b2/238e2590826bfdd113244a40d9d3eb26918bd798fc187e2360a8367068db/six-1.10.0.tar.gz"
    sha256 "105f8d68616f8248e24bf0e9372ef04d3cc10104f1980f54d57b2ce73a5ad56a"
  end

  resource "sseclient" do
    url "https://files.pythonhosted.org/packages/01/b2/58df4fcd9fa6c70ed4c19a09841227378d78388687cd461926de3cb4743d/sseclient-0.0.14.tar.gz"
    sha256 "fb07aeb662033cc5924d66455cb4aa77e9660eec340eaeb801ddeefa032fbda8"
  end

  resource "toml" do
    url "https://files.pythonhosted.org/packages/5c/b2/8a18ced00a43f2cc5261f9ac9f1c94621251400a80db1567177719355177/toml-0.9.2.tar.gz"
    sha256 "b3953bffe848ad9a6d554114d82f2dcb3e23945e90b4d9addc9956f37f336594"
  end

  resource "virtualenv" do
    url "https://files.pythonhosted.org/packages/d4/0c/9840c08189e030873387a73b90ada981885010dd9aea134d6de30cd24cb8/virtualenv-15.1.0.tar.gz"
    sha256 "02f8102c2436bb03b3ee6dede1919d1dac8a427541652e5ec95171ec8adbc93a"
  end

  def install
    venv = virtualenv_create(libexec, "python3")
    venv.pip_install resources
    venv.pip_install [buildpath, buildpath/"cli"]
    bin.install_symlink libexec/"bin/dcos"
  end

  test do
    assert_match "dcoscli.version=", shell_output("#{bin}/dcos --version")
    assert_match "dcos \[options\] \[\<command\>\] \[\<args\>...\]", shell_output("#{bin}/dcos --help")
  end
end
