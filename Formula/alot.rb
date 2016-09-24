class Alot < Formula
  include Language::Python::Virtualenv

  desc "Text mode MUA using notmuch mail"
  homepage "https://github.com/pazz/alot"
  url "https://github.com/pazz/alot/archive/0.3.7.tar.gz"
  sha256 "fd2d4121ba109224560919e84e320b09526891fbc0038afcea26a3f1284dad26"
  head "https://github.com/pazz/alot.git", :branch => "testing"

  bottle do
    cellar :any
    sha256 "3f181ad220a8c70237ba564d30b0da7475921d8644702fea31f88167ca71df81" => :el_capitan
    sha256 "d48c2504956c24c88a64876946efa8a5a284829839fa7165a59b9e9e2ef03550" => :yosemite
    sha256 "257b06000d6ac02a509acd7161567d753d8ad31abba99bd0a0af4cdcac39486a" => :mavericks
  end

  option "without-sphinx-doc", "Don't build documentation"

  depends_on "gpgme"
  depends_on "libmagic"
  depends_on "notmuch"
  depends_on "sphinx-doc" => [:build, :recommended]

  resource "six" do
    url "https://pypi.python.org/packages/source/s/six/six-1.10.0.tar.gz"
    sha256 "105f8d68616f8248e24bf0e9372ef04d3cc10104f1980f54d57b2ce73a5ad56a"
  end

  resource "configobj" do
    url "https://pypi.python.org/packages/source/c/configobj/configobj-5.0.6.tar.gz"
    sha256 "a2f5650770e1c87fb335af19a9b7eb73fc05ccf22144eb68db7d00cd2bcb0902"
  end

  resource "zope.interface" do
    url "https://pypi.python.org/packages/ea/a3/38bdc8e8bd068ea5b4d21a2d80eca1547cd8509318e8d7c875f7247abe43/zope.interface-4.2.0.tar.gz"
    sha256 "36762743940a075283e1fb22a2ec9e8231871dace2aa00599511ddc4edf0f8f9"
  end

  resource "twisted" do
    url "https://pypi.python.org/packages/18/85/eb7af503356e933061bf1220033c3a85bad0dbc5035dfd9a97f1e900dfcb/Twisted-16.2.0.tar.bz2"
    sha256 "a090e8dc675e97fb20c3bb5f8114ae94169f4e29fd3b3cbede35705fd3cdbd79"
  end

  resource "urwid" do
    url "https://pypi.python.org/packages/source/u/urwid/urwid-1.3.1.tar.gz"
    sha256 "cfcec03e36de25a1073e2e35c2c7b0cc6969b85745715c3a025a31d9786896a1"
  end

  resource "urwidtrees" do
    url "https://github.com/pazz/urwidtrees/archive/1.0.2.tar.gz"
    sha256 "703f4b161b930a26a461a3e3e695f94237ac75e2a52b87613e49093d9aa76034"
  end

  resource "pygpgme" do
    url "https://pypi.python.org/packages/source/p/pygpgme/pygpgme-0.3.tar.gz"
    sha256 "5fd887c407015296a8fd3f4b867fe0fcca3179de97ccde90449853a3dfb802e1"
  end

  resource "python-magic" do
    url "https://pypi.python.org/packages/source/p/python-magic/python-magic-0.4.11.tar.gz"
    sha256 "89021e288d6efd22cde2842349d79939b9664efdbf99f5790c9862a67759ea94"
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
      sleep 2
    ensure
      Process.kill 9, pid
    end

    assert (testpath/"out.log").exist?, "out.log file should exist"
    assert_match "setup gui", File.read(testpath/"out.log")
  end
end
