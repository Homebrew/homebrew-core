class Fabric < Formula
  desc "Library and command-line tool for SSH"
  homepage "http://www.fabfile.org"
  url "https://github.com/fabric/fabric/archive/1.12.0.tar.gz"
  sha256 "c58d51963b77b0e55aa7ebd800b86217851a40d8abf3247a2a0c358a226344ff"
  head "https://github.com/fabric/fabric.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "e8d5a5ab06d133c2fc5617b276b119a5a4b1ca8567bc1697d622e27b1a612edf" => :sierra
    sha256 "8cbff630aac360476908923a566c858b1fb6748742ca3cb5b09b9fe8ee341e03" => :el_capitan
    sha256 "bb39fa519461b1eb648b071a8cd06e13f4c10cda1fcd01b02a44be422019c37a" => :yosemite
  end

  depends_on :python if MacOS.version <= :snow_leopard

  resource "ecdsa" do
    url "https://files.pythonhosted.org/packages/f9/e5/99ebb176e47f150ac115ffeda5fedb6a3dbb3c00c74a59fd84ddf12f5857/ecdsa-0.13.tar.gz"
    sha256 "64cf1ee26d1cde3c73c6d7d107f835fed7c6a2904aef9eac223d57ad800c43fa"
  end

  resource "paramiko" do
    url "https://files.pythonhosted.org/packages/0c/ea/3581ba57d152fab6e3e928363d498848c7a50ab43b32bb81867bd803b9ba/paramiko-1.17.2.tar.gz"
    sha256 "d436971492bf11fb9807c08f41d4115a82bd592a844971737a6a8e8900c4677c"
  end

  resource "pycrypto" do
    url "https://files.pythonhosted.org/packages/60/db/645aa9af249f059cc3a368b118de33889219e0362141e75d4eaf6f80f163/pycrypto-2.6.1.tar.gz"
    sha256 "f2ce1e989b272cfcb677616763e0a2e7ec659effa67a88aa92b3a65528f60a3c"
  end

  def install
    ENV.prepend_create_path "PYTHONPATH", libexec/"vendor/lib/python2.7/site-packages"
    resources.each do |r|
      r.stage do
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
      def hello():
        print("Hello world!")
    EOS
    expected = <<-EOS.undent
      Hello world!

      Done.
    EOS
    assert_equal expected, shell_output("#{bin}/fab hello")
  end
end
