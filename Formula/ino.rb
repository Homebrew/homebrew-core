class Ino < Formula
  desc "Command-line toolkit for working with Arduino hardware"
  homepage "http://inotool.org"
  url "https://pypi.python.org/packages/source/i/ino/ino-0.3.6.tar.gz"
  sha256 "9b675dc69d7a332ff65632bdffd671537b5eedce4e110ee4daca956299fbd44c"

  bottle do
    cellar :any_skip_relocation
    sha256 "cfd6fb6e8e05af32a75064404ed6217bcac47c9d7dfb1bd3c53bfd60fa2c4dd4" => :high_sierra
    sha256 "ba6d8a28197816999132d07732bf522e8b50f5c8030aba43b2fa48556c9c8115" => :sierra
    sha256 "fe8bd44bff433014afad389f2afd63253ac747eba19ecbd055f2f37bef236430" => :el_capitan
    sha256 "326863d7187f8c280a39c0d20a5ef568ad58a6c2f9d5f20d9fba75f4d2c2f03d" => :yosemite
    sha256 "a2a0aeb71d02e6d67578f9c3265fa2b11ef716bc47519f3b31d001f9712e8b6e" => :mavericks
  end

  depends_on "picocom"
  depends_on "python" if MacOS.version <= :snow_leopard

  resource "argparse" do
    url "https://pypi.python.org/packages/source/a/argparse/argparse-1.2.1.tar.gz"
    sha256 "ddaf4b0a618335a32b6664d4ae038a1de8fbada3b25033f9021510ed2b3941a4"
  end

  resource "ordereddict" do
    url "https://pypi.python.org/packages/source/o/ordereddict/ordereddict-1.1.tar.gz"
    sha256 "1c35b4ac206cef2d24816c89f89cf289dd3d38cf7c449bb3fab7bf6d43f01b1f"
  end

  resource "configobj" do
    url "https://pypi.python.org/packages/source/c/configobj/configobj-5.0.5.tar.gz"
    sha256 "766eff273f2cbb007a3ea8aa69429ee9b1553aa96fe282c6ace3769b9ac47b08"
  end

  resource "pyserial" do
    url "https://pypi.python.org/packages/source/p/pyserial/pyserial-2.7.tar.gz"
    sha256 "3542ec0838793e61d6224e27ff05e8ce4ba5a5c5cc4ec5c6a3e8d49247985477"
  end

  resource "six" do
    url "https://pypi.python.org/packages/source/s/six/six-1.7.2.tar.gz"
    sha256 "c7b85e433ecf2f2df37edb017b954c468342991e1883c8a1e8d8616584b69998"
  end

  resource "markupsafe" do
    url "https://pypi.python.org/packages/source/M/MarkupSafe/MarkupSafe-0.23.tar.gz"
    sha256 "a4ec1aff59b95a14b45eb2e23761a0179e98319da5a7eb76b56ea8cdc7b871c3"
  end

  resource "jinja2" do
    url "https://pypi.python.org/packages/source/J/Jinja2/Jinja2-2.7.3.tar.gz"
    sha256 "2e24ac5d004db5714976a04ac0e80c6df6e47e98c354cb2c0d82f8879d4f8fdb"
  end

  def install
    ENV["PYTHONPATH"] = lib+"python2.7/site-packages"
    ENV.prepend_create_path "PYTHONPATH", libexec+"lib/python2.7/site-packages"
    ENV.prepend_create_path "PYTHONPATH", prefix+"lib/python2.7/site-packages"

    resources.each do |r|
      r.stage { system "python", "setup.py", "install", "--prefix=#{libexec}" }
    end

    system "python", "setup.py", "install", "--prefix=#{prefix}"

    rm Dir["#{lib}/python2.7/site-packages/*.pth"]

    bin.env_script_all_files(libexec+"bin", :PYTHONPATH => ENV["PYTHONPATH"])
  end

  test do
    system "#{bin}/ino", "--help"
  end
end
