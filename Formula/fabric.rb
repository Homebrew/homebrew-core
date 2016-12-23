class Fabric < Formula
  desc "Library and command-line tool for SSH"
  homepage "http://www.fabfile.org"
  url "https://github.com/fabric/fabric/archive/1.13.1.tar.gz"
  sha256 "59ee3b780e0cd3b8c5db7333d2006a5f932e8e79e2f334aec76c6f97b298bac6"
  revision 1
  head "https://github.com/fabric/fabric.git"

  bottle do
    cellar :any
    sha256 "d48eb3d28f2b9ad592dc091114a589de3057815057b686a124cd6e31838843b2" => :sierra
    sha256 "518acfd7457a5d31375591da6496eb2084efa08c3cec1f93fb250ade4ae1b9d5" => :el_capitan
    sha256 "6c56c3d10921be289032f3dd561047ed26db67dcfca686a9092f587709f02f7f" => :yosemite
  end

  depends_on :python if MacOS.version <= :snow_leopard
  depends_on "openssl"

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/6b/b2/b79df1b728dc14469269844cbd6cbe82c71a16839a131c60357b13117c96/setuptools-32.1.1.tar.gz"
    sha256 "8303fb24306385f09bf8b0e5a385c1548e42e8efc08558d64049bc0d55ea012d"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/b3/b2/238e2590826bfdd113244a40d9d3eb26918bd798fc187e2360a8367068db/six-1.10.0.tar.gz"
    sha256 "105f8d68616f8248e24bf0e9372ef04d3cc10104f1980f54d57b2ce73a5ad56a"
  end

  resource "idna" do
    url "https://pypi.python.org/packages/fb/84/8c27516fbaa8147acd2e431086b473c453c428e24e8fb99a1d89ce381851/idna-2.1.tar.gz"
    sha256 "ed36f281aebf3cd0797f163bb165d84c31507cedd15928b095b1675e2d04c676"
  end

  resource "ipaddress" do
    url "https://files.pythonhosted.org/packages/bb/26/3b64955ff73f9e3155079b9ed31812afdfa5333b5c76387454d651ef593a/ipaddress-1.0.17.tar.gz"
    sha256 "3a21c5a15f433710aaa26f1ae174b615973a25182006ae7f9c26de151cd51716"
  end

  resource "enum34" do
    url "https://files.pythonhosted.org/packages/bf/3e/31d502c25302814a7c2f1d3959d2a3b3f78e509002ba91aea64993936876/enum34-1.1.6.tar.gz"
    sha256 "8ad8c4783bf61ded74527bffb48ed9b54166685e4230386a9ed9b1279e2df5b1"
  end

  resource "pyasn1" do
    url "https://files.pythonhosted.org/packages/f7/83/377e3dd2e95f9020dbd0dfd3c47aaa7deebe3c68d3857a4e51917146ae8b/pyasn1-0.1.9.tar.gz"
    sha256 "853cacd96d1f701ddd67aa03ecc05f51890135b7262e922710112f12a2ed2a7f"
  end

  resource "pycparser" do
    url "https://files.pythonhosted.org/packages/be/64/1bb257ffb17d01f4a38d7ce686809a736837ad4371bcc5c42ba7a715c3ac/pycparser-2.17.tar.gz"
    sha256 "0aac31e917c24cb3357f5a4d5566f2cc91a19ca41862f6c3c22dc60a629673b6"
  end

  resource "cffi" do
    url "https://files.pythonhosted.org/packages/a1/32/e3d6c3a8b5461b903651dd6ce958ed03c093d2e00128e3f33ea69f1d7965/cffi-1.9.1.tar.gz"
    sha256 "563e0bd53fda03c151573217b3a49b3abad8813de9dd0632e10090f6190fdaf8"
  end

  resource "cryptography" do
    url "https://files.pythonhosted.org/packages/82/f7/d6dfd7595910a20a563a83a762bf79a253c4df71759c3b228accb3d7e5e4/cryptography-1.7.1.tar.gz"
    sha256 "953fef7d40a49a795f4d955c5ce4338abcec5dea822ed0414ed30348303fdb4c"
  end

  resource "paramiko" do
    url "https://files.pythonhosted.org/packages/d1/5a/ebd00d884f30baf208359a027eb7b38372d81d0c004724bb1aa71ae43b37/paramiko-2.1.1.tar.gz"
    sha256 "d51dada7ad0736c116f8bfe3263627925947e4a50e61436a83d58bfe7055b575"
  end

  def install
    ENV.prepend_create_path "PYTHONPATH", libexec/"vendor/lib/python2.7/site-packages"
    resources.each do |r|
      r.stage do
        if r.name == "cryptography" && MacOS.version < :sierra
          # Fixes .../cryptography/hazmat/bindings/_openssl.so: Symbol not found: _getentropy
          # Reported 20 Dec 2016 https://github.com/pyca/cryptography/issues/3332
          inreplace "src/_cffi_src/openssl/src/osrandom_engine.h",
            "#elif defined(BSD) && defined(SYS_getentropy)",
            "#elif defined(BSD) && defined(SYS_getentropy) && 0"
        end
        system "python", *Language::Python.setup_install_args(libexec/"vendor")
      end
    end

    ENV.prepend_create_path "PYTHONPATH", libexec/"lib/python2.7/site-packages"
    system "python", *Language::Python.setup_install_args(libexec)

    bin.install Dir[libexec/"bin/*"]
    bin.env_script_all_files(libexec/"bin", :PYTHONPATH => ENV["PYTHONPATH"])
  end

  test do
    (testpath/"fabfile.py").write <<-EOS.undent
      from fabric.api import task, puts, env
      @task
      def hello():
        puts("fabric " + env.version)
    EOS
    expected = <<-EOS.undent
      fabric #{version}

      Done.
    EOS
    assert_equal expected, shell_output("#{bin}/fab hello")
  end
end
