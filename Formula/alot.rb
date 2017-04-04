class Alot < Formula
  include Language::Python::Virtualenv

  desc "Text mode MUA using notmuch mail"
  homepage "https://github.com/pazz/alot"
  url "https://github.com/pazz/alot/archive/0.5.1.tar.gz"
  sha256 "6a74fc9e8069a1d24da27f3d06981fc6871d386ee14578687578d62f21185d71"
  head "https://github.com/pazz/alot.git"

  bottle do
    cellar :any
    sha256 "e61395294016c2099770ebfa122323390c4ae18425c43ed4111ca27920f29eae" => :sierra
    sha256 "b6285551f360aec2963aaa4ccf880f232f6a787a7e8777c88e348afd8a4fa7ae" => :el_capitan
    sha256 "868b6e9e5e7202f07cb187ce5e741db34566594d71640929c2f43befc7882a30" => :yosemite
  end

  option "without-sphinx-doc", "Don't build documentation"

  depends_on "gpgme"
  depends_on "libmagic"
  depends_on "notmuch"
  depends_on "sphinx-doc" => [:build, :recommended]

  resource "six" do
    url "https://files.pythonhosted.org/packages/b3/b2/238e2590826bfdd113244a40d9d3eb26918bd798fc187e2360a8367068db/six-1.10.0.tar.gz"
    sha256 "105f8d68616f8248e24bf0e9372ef04d3cc10104f1980f54d57b2ce73a5ad56a"
  end

  resource "configobj" do
    url "https://files.pythonhosted.org/packages/64/61/079eb60459c44929e684fa7d9e2fdca403f67d64dd9dbac27296be2e0fab/configobj-5.0.6.tar.gz"
    sha256 "a2f5650770e1c87fb335af19a9b7eb73fc05ccf22144eb68db7d00cd2bcb0902"
  end

  resource "zope.interface" do
    url "https://files.pythonhosted.org/packages/38/1b/d55c39f2cf442bd9fb2c59760ed058c84b57d25c680819c25f3aff741e1f/zope.interface-4.3.2.tar.gz"
    sha256 "6a0e224a052e3ce27b3a7b1300a24747513f7a507217fcc2a4cb02eb92945cee"
  end

  resource "Twisted" do
    url "https://files.pythonhosted.org/packages/dc/c0/a0114a6d7fa211c0904b0de931e8cafb5210ad824996cc6a9d67f3bae22c/Twisted-16.6.0.tar.bz2"
    sha256 "d0fe115ea7ef8cf632d05103de60356c6e992b2153d6830bdc4476f8accb1fca"
  end

  resource "urwid" do
    url "https://files.pythonhosted.org/packages/85/5d/9317d75b7488c335b86bd9559ca03a2a023ed3413d0e8bfe18bea76f24be/urwid-1.3.1.tar.gz"
    sha256 "cfcec03e36de25a1073e2e35c2c7b0cc6969b85745715c3a025a31d9786896a1"
  end

  resource "urwidtrees" do
    url "https://files.pythonhosted.org/packages/88/9d/981617fa083a75cf0b5ebb0ae47c3af6fb69183be1c74cc3ac6d9a0c5964/urwidtrees-1.0.1.1.tar.gz"
    sha256 "08a66d0e76e94bc32bc590e35ed283e8a6b0c93adeb431dc576ec0a345f09bfd"
  end

  resource "pygpgme" do
    url "https://files.pythonhosted.org/packages/dc/96/b2bcbd3a216af313bb9045c2e573aa18653876a65db471b86be7598234dd/pygpgme-0.3.tar.gz"
    sha256 "5fd887c407015296a8fd3f4b867fe0fcca3179de97ccde90449853a3dfb802e1"
  end

  resource "python-magic" do
    url "https://files.pythonhosted.org/packages/d8/94/4b2930f2146c1318e6250c85d884c87720f3089085e4d4ba53fa0f8c620c/python-magic-0.4.12.tar.gz"
    sha256 "a04b20900100884d4fce40a767182a16fcb9d10756c67cdc21f5fa610b7c9d3c"
  end

  resource "incremental" do
    url "https://files.pythonhosted.org/packages/da/b0/32233c9e84b0d44b39015fba8fec03e88053723c1b455925081dc6ccd9e7/incremental-16.10.1.tar.gz"
    sha256 "14ad6b720ec47aad6c9caa83e47db1843e2b9b98742da5dda08e16a99f400342"
  end

  resource "constantly" do
    url "https://files.pythonhosted.org/packages/95/f1/207a0a478c4bb34b1b49d5915e2db574cadc415c9ac3a7ef17e29b2e8951/constantly-15.1.0.tar.gz"
    sha256 "586372eb92059873e29eba4f9dec8381541b4d3834660707faf8ba59146dfc35"
  end

  def install
    virtualenv_install_with_resources
    pkgshare.install Dir["extra/*"] - %w[extra/completion]
    zsh_completion.install "extra/completion/alot-completion.zsh" => "_alot"

    if build.with? "sphinx-doc"
      ENV["LC_ALL"] = "en_US.UTF-8"
      ENV["SPHINXBUILD"] = Formula["sphinx-doc"].opt_bin/"sphinx-build"
      cd "docs" do
        system "make", "pickle"
        system "make", "man", "html"
        man1.install "build/man/alot.1"
        doc.install Dir["build/html/*"]
      end
    end
  end

  test do
    (testpath/".notmuch-config").write "[database]\npath=#{testpath}/Mail"
    (testpath/"Mail").mkpath
    system Formula["notmuch"].bin/"notmuch", "new"

    begin
      pid = fork do
        $stdout.reopen("/dev/null")
        $stdin.reopen("/dev/null")
        exec "script", "-q", "/dev/null", bin/"alot", "--logfile", testpath/"out.log"
      end
      sleep 10
    ensure
      Process.kill 9, pid
    end

    assert (testpath/"out.log").exist?, "out.log file should exist"
    assert_match "setup gui", File.read(testpath/"out.log")
  end
end
