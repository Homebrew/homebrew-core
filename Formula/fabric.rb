class Fabric < Formula
  desc "Library and command-line tool for SSH"
  homepage "http://www.fabfile.org"
  url "https://github.com/fabric/fabric/archive/1.11.1.tar.gz"
  sha256 "b84e635e2ddd98119aabfffb99e8ec022d0533d7bfd68e7c491b5ac02f394cef"
  head "https://github.com/fabric/fabric.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "99e1479291e89efe294cdd094741dc70154d644633877add11a9b1a39c7fee62" => :el_capitan
    sha256 "ddaccc0db8c861b4f1d5d0fec3d845ff440f86af3a28751a299ad7784253ba1d" => :yosemite
    sha256 "044c9dec4d5021abd8b4c356e8ff0bfc5968115267b030219f010ff5b97abfbf" => :mavericks
    sha256 "768df88335578704b1029b859ab7d36654cb5b20bfd1b0bc64e487476b7c214e" => :mountain_lion
  end

  depends_on :python if MacOS.version <= :snow_leopard

  resource "ecdsa" do
    url "https://files.pythonhosted.org/packages/f9/e5/99ebb176e47f150ac115ffeda5fedb6a3dbb3c00c74a59fd84ddf12f5857/ecdsa-0.13.tar.gz"
    sha256 "64cf1ee26d1cde3c73c6d7d107f835fed7c6a2904aef9eac223d57ad800c43fa"
  end

  resource "paramiko" do
    url "https://files.pythonhosted.org/packages/b8/60/f83c7f27d15560c731fb7f39f308b5d056785a0cbb0b5c87ee3767b0db4c/paramiko-1.17.1.tar.gz"
    sha256 "d67df9bd32e63d9a68900a7cad520c74b6f23d631417c662c265e80f7ad61ca7"
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
