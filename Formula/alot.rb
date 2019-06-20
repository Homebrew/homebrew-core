class Alot < Formula
  include Language::Python::Virtualenv

  desc "Text mode MUA using notmuch mail"
  homepage "https://github.com/pazz/alot"
  url "https://github.com/pazz/alot/archive/0.8.1.tar.gz"
  sha256 "823e2fae014c1036609068c6109042b676113a382eacbd04eb3dfa461ef53953"
  head "https://github.com/pazz/alot.git"

  bottle do
    cellar :any
    sha256 "adbbdac0378bf3c5a1d5cf86190b0bdd7bff2569fd7fb3d254fd2bd5bae1e7fe" => :mojave
    sha256 "79c1bdd07fa75983d06f4a6c27e81741d0553e3635dd3836c65dc6f3c08c0954" => :high_sierra
    sha256 "227895c908fda25c07555e5514b067d086d6d961f71a40c2098763cfd63deccd" => :sierra
    sha256 "ba94977585c50e29025be7e592a31809d2f520d50fdb8f023a445dc78ca1bd9d" => :el_capitan
  end

  depends_on "sphinx-doc" => :build
  depends_on "swig" => :build
  depends_on "gpgme"
  depends_on "libmagic"
  depends_on "notmuch"
  depends_on "python"

  resource "Automat" do
    url "https://files.pythonhosted.org/packages/4a/4f/64db3ffda8828cb0541fe949354615f39d02f596b4c33fb74863756fc565/Automat-0.7.0.tar.gz"
    sha256 "cbd78b83fa2d81fe2a4d23d258e1661dd7493c9a50ee2f1a5b2cac61c1793b0e"
  end

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/cc/d9/931a24cc5394f19383fbbe3e1147a0291276afa43a0dc3ed0d6cd9fda813/attrs-19.1.0.tar.gz"
    sha256 "f0b870f674851ecbfbbbd364d6b5cbdff9dcedbc7f3f5e18a6891057f21fe399"
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
    url "https://files.pythonhosted.org/packages/ef/86/c5a34243a932346c59cb25eb49a4d1dec227974209eb9b618d0ed57ea5be/gpg-1.10.0.tar.gz"
    sha256 "349214a866c84aa548bc35ed14eccd2ec9085b3958d5753a63a19a71a1f523ca"
  end

  resource "hyperlink" do
    url "https://files.pythonhosted.org/packages/e0/46/1451027b513a75edf676d25a47f601ca00b06a6a7a109e5644d921e7462d/hyperlink-19.0.0.tar.gz"
    sha256 "4288e34705da077fada1111a24a0aa08bb1e76699c9ce49876af722441845654"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/ad/13/eb56951b6f7950cadb579ca166e448ba77f9d24efc03edd7e55fa57d04b7/idna-2.8.tar.gz"
    sha256 "c357b3f628cf53ae2c4c05627ecc484553142ca23264e593d327bcde5e9c3407"
  end

  resource "incremental" do
    url "https://files.pythonhosted.org/packages/8f/26/02c4016aa95f45479eea37c90c34f8fab6775732ae62587a874b619ca097/incremental-17.5.0.tar.gz"
    sha256 "7b751696aaf36eebfab537e458929e194460051ccad279c72b755a167eebd4b3"
  end

  resource "PyHamcrest" do
    url "https://files.pythonhosted.org/packages/a4/89/a469aad9256aedfbb47a29ec2b2eeb855d9f24a7a4c2ff28bd8d1042ef02/PyHamcrest-1.9.0.tar.gz"
    sha256 "8ffaa0a53da57e89de14ced7185ac746227a8894dbd5a3c718bf05ddbd1d56cd"
  end

  resource "python-magic" do
    url "https://files.pythonhosted.org/packages/84/30/80932401906eaf787f2e9bd86dc458f1d2e75b064b4c187341f29516945c/python-magic-0.4.15.tar.gz"
    sha256 "f3765c0f582d2dfc72c15f3b5a82aecfae9498bd29ca840d72f37d7bd38bfcd5"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/dd/bf/4138e7bfb757de47d1f4b6994648ec67a51efe58fa907c1e11e350cddfca/six-1.12.0.tar.gz"
    sha256 "d16a0141ec1a18405cd4ce8b4613101da75da0e9a7aec5bdd4fa804d0e0eba73"
  end

  resource "Twisted" do
    url "https://files.pythonhosted.org/packages/79/59/035de19362320e632301ed7bbde23e4c8cd6fc5e2f1cf8d354cdba857854/Twisted-19.2.1.tar.bz2"
    sha256 "fa2c04c2d68a9be7fc3975ba4947f653a57a656776f24be58ff0fe4b9aaf3e52"
  end

  resource "urwid" do
    url "https://files.pythonhosted.org/packages/c7/90/415728875c230fafd13d118512bde3184d810d7bf798a631abc05fac09d0/urwid-2.0.1.tar.gz"
    sha256 "644d3e3900867161a2fc9287a9762753d66bd194754679adb26aede559bcccbc"
  end

  resource "urwidtrees" do
    url "https://files.pythonhosted.org/packages/88/9d/981617fa083a75cf0b5ebb0ae47c3af6fb69183be1c74cc3ac6d9a0c5964/urwidtrees-1.0.1.1.tar.gz"
    sha256 "08a66d0e76e94bc32bc590e35ed283e8a6b0c93adeb431dc576ec0a345f09bfd"
  end

  resource "zope.interface" do
    url "https://files.pythonhosted.org/packages/4e/d0/c9d16bd5b38de44a20c6dc5d5ed80a49626fafcb3db9f9efdc2a19026db6/zope.interface-4.6.0.tar.gz"
    sha256 "1b3d0dcabc7c90b470e59e38a9acaa361be43b3a6ea644c0063951964717f0e5"
  end

  def install
    virtualenv_install_with_resources
    pkgshare.install Dir["extra/*"] - %w[extra/completion]
    zsh_completion.install "extra/completion/alot-completion.zsh" => "_alot"

    ENV["LC_ALL"] = "en_US.UTF-8"
    ENV["SPHINXBUILD"] = Formula["sphinx-doc"].opt_bin/"sphinx-build"
    cd "docs" do
      system "make", "pickle"
      system "make", "man", "html"
      man1.install "build/man/alot.1"
      doc.install Dir["build/html/*"]
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

    assert_predicate testpath/"out.log", :exist?, "out.log file should exist"
    assert_match "setup gui", File.read(testpath/"out.log")
  end
end
