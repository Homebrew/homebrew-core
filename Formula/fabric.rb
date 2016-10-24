class Fabric < Formula
  desc "Library and command-line tool for SSH"
  homepage "http://www.fabfile.org"
  url "https://github.com/fabric/fabric/archive/1.12.0.tar.gz"
  sha256 "c58d51963b77b0e55aa7ebd800b86217851a40d8abf3247a2a0c358a226344ff"
  head "https://github.com/fabric/fabric.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "de208b09fea91273f8009cb78f046b5d477260cb737a4e10e35e5c075401bab0" => :sierra
    sha256 "480091211543a166bac74de897613af4948648b7225ae68e3c17f9b6c07319f5" => :el_capitan
    sha256 "7e308a0dfb0976b1ce19e855506f580c2a6810546f75faa4b886dc43f68d95aa" => :yosemite
    sha256 "22ec807c8b8add709b9f13b54cb31211fa355109b62a4dd20c82756441194921" => :mavericks
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
