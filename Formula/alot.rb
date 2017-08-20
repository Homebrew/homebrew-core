class Alot < Formula
  include Language::Python::Virtualenv

  desc "Text mode MUA using notmuch mail"
  homepage "https://github.com/pazz/alot"
  url "https://github.com/pazz/alot/archive/0.6.tar.gz"
  sha256 "36b4b3471e2815b3fac320d3b82be5c4252dce119d3d3112dcbf69dd67f0acb2"
  head "https://github.com/pazz/alot.git"

  bottle do
    cellar :any
    sha256 "9939df295cbce9cb3e670696cc3fde360cd92f8a18659f406a8b59f10878ea23" => :sierra
    sha256 "52bd6a8cfb10e89efca23fbddaeb91b5efa3e1ff1ef9077696660c14cca69ff3" => :el_capitan
    sha256 "ba467d9c7bb1343ab3ab71e87342cd3f3a17504ec2efa1bcea667a82626e61d3" => :yosemite
  end

  option "without-sphinx-doc", "Don't build documentation"

  depends_on "swig" => :build
  depends_on "gpgme"
  depends_on "libmagic"
  depends_on "notmuch"
  depends_on "sphinx-doc" => [:build, :recommended]

  resource "Automat" do
    url "https://files.pythonhosted.org/packages/de/05/b8e453085cf8a7f27bb1226596f4ccf5cc9e758377d60284f990bbdc592c/Automat-0.6.0.tar.gz"
    sha256 "3c1fd04ecf08ac87b4dd3feae409542e9bf7827257097b2b6ed5692f69d6f6a8"
  end

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/be/41/e909cb6d901e9689da947419505cc7fb7d242a08a62ee221fce6a009a523/attrs-17.2.0.tar.gz"
    sha256 "5d4d1b99f94d69338f485984127e4473b3ab9e20f43821b0e546cc3b2302fd11"
  end

  resource "configobj" do
    url "https://files.pythonhosted.org/packages/64/61/079eb60459c44929e684fa7d9e2fdca403f67d64dd9dbac27296be2e0fab/configobj-5.0.6.tar.gz"
    sha256 "a2f5650770e1c87fb335af19a9b7eb73fc05ccf22144eb68db7d00cd2bcb0902"
  end

  resource "constantly" do
    url "https://files.pythonhosted.org/packages/95/f1/207a0a478c4bb34b1b49d5915e2db574cadc415c9ac3a7ef17e29b2e8951/constantly-15.1.0.tar.gz"
    sha256 "586372eb92059873e29eba4f9dec8381541b4d3834660707faf8ba59146dfc35"
  end

  resource "gpg" do
    url "https://files.pythonhosted.org/packages/9f/46/4f6b63d1b5b82bac52b5b7723df8cd66a4864dc29861aa14d2d2de4a57f5/gpg-1.8.0.tar.gz"
    sha256 "cd26e8a77c907e0d9f14a627bf71729456fd26aa2d1f4d275b808d70b089e4f4"
  end

  resource "hyperlink" do
    url "https://files.pythonhosted.org/packages/83/df/3bdaf38f21f93429de02f04c6a967d2154955fc5b9a6a1a0b20a682edc13/hyperlink-17.3.1.tar.gz"
    sha256 "bc4ffdbde9bdad204d507bd8f554f16bba82dd356f6130cb16f41422909c33bc"
  end

  resource "incremental" do
    url "https://files.pythonhosted.org/packages/8f/26/02c4016aa95f45479eea37c90c34f8fab6775732ae62587a874b619ca097/incremental-17.5.0.tar.gz"
    sha256 "7b751696aaf36eebfab537e458929e194460051ccad279c72b755a167eebd4b3"
  end

  resource "python-magic" do
    url "https://files.pythonhosted.org/packages/65/0b/c6b31f686420420b5a16b24a722fe980724b28d76f65601c9bc324f08d02/python-magic-0.4.13.tar.gz"
    sha256 "604eace6f665809bebbb07070508dfa8cabb2d7cb05be9a56706c60f864f1289"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/b3/b2/238e2590826bfdd113244a40d9d3eb26918bd798fc187e2360a8367068db/six-1.10.0.tar.gz"
    sha256 "105f8d68616f8248e24bf0e9372ef04d3cc10104f1980f54d57b2ce73a5ad56a"
  end

  resource "Twisted" do
    url "https://files.pythonhosted.org/packages/31/bf/7f86a8f8b9778e90d8b2921e9f442a8c8aa33fd2489fc10f236bc8af1749/Twisted-17.5.0.tar.bz2"
    sha256 "f198a494f0df2482f7c5f99d7f3eef33d22763ffc76641b36fec476b878002ea"
  end

  resource "urwid" do
    url "https://files.pythonhosted.org/packages/85/5d/9317d75b7488c335b86bd9559ca03a2a023ed3413d0e8bfe18bea76f24be/urwid-1.3.1.tar.gz"
    sha256 "cfcec03e36de25a1073e2e35c2c7b0cc6969b85745715c3a025a31d9786896a1"
  end

  resource "urwidtrees" do
    url "https://files.pythonhosted.org/packages/88/9d/981617fa083a75cf0b5ebb0ae47c3af6fb69183be1c74cc3ac6d9a0c5964/urwidtrees-1.0.1.1.tar.gz"
    sha256 "08a66d0e76e94bc32bc590e35ed283e8a6b0c93adeb431dc576ec0a345f09bfd"
  end

  resource "zope.interface" do
    url "https://files.pythonhosted.org/packages/c5/88/93373971f893714f0dc15e09696ec4886ee8b4e561ce5ae45612c2c516c4/zope.interface-4.4.2.tar.gz"
    sha256 "4e59e427200201f69ef82956ddf9e527891becf5b7cde8ec3ce39e1d0e262eb0"
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
