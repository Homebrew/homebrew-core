class Dxpy < Formula
  include Language::Python::Virtualenv

  desc "DNAnexus toolkit utilities and platform API bindings for Python"
  homepage "https://github.com/dnanexus/dx-toolkit"
  url "https://files.pythonhosted.org/packages/04/16/1d1e1ff25d4f694f04f88417afbd72703d850aebe9f84fdbb8ed836089d7/dxpy-0.191.0.tar.gz"
  sha256 "b98a55fc766a9e7044f6f299d148c5dde3967f22669add915a1a1921e4006820"
  revision 1

  bottle do
    cellar :any_skip_relocation
    sha256 "526ed51259393fb569a912b8865e1627af6ebae9bccd460d33cb403027c66e52" => :sierra
    sha256 "08e04fb3cdca5a1d50229e76713fd6a7f384996ed1e30c97a5260118dbf75a91" => :el_capitan
    sha256 "b5a5feb625e40d2bffca2a5be08bd4977a55129d7c9925129b50c51b782f5399" => :yosemite
    sha256 "91a3634cb4366db887baf1e250bce3c978f9283a2a37593e676440a3a4791adf" => :mavericks
  end

  depends_on :python if MacOS.version <= :snow_leopard

  conflicts_with "android-sdk", :because => "both install `dx` binaries"

  resource "beautifulsoup4" do
    url "https://files.pythonhosted.org/packages/26/79/ef9a8bcbec5abc4c618a80737b44b56f1cb393b40238574078c5002b97ce/beautifulsoup4-4.4.1.tar.gz"
    sha256 "87d4013d0625d4789a4f56b8d79a04d5ce6db1152bb65f1d39744f7709a366b4"
  end

  resource "fusepy" do
    url "https://files.pythonhosted.org/packages/0f/4d/26a937988e2633aa9f1d5268aa3782afaee9a482c6c6f221fc1e1ae58862/fusepy-2.0.2.tar.gz"
    sha256 "aa5929d5464caed81406481a330dc975d1a95b9a41d0a98f095c7e18fe501bfc"
  end

  resource "futures" do
    url "https://files.pythonhosted.org/packages/8d/73/b5fff618482bc06c9711e7cdc0d5d7eb1904d35898f48f2d7f9696b08bef/futures-3.0.4.tar.gz"
    sha256 "19485d83f7bd2151c0aeaf88fbba3ee50dadfb222ffc3b66a344ef4952b782a3"
  end

  resource "gnureadline" do
    url "https://files.pythonhosted.org/packages/3a/ee/2c3f568b0a74974791ac590ec742ef6133e2fbd287a074ba72a53fa5e97c/gnureadline-6.3.3.tar.gz"
    sha256 "a259b038f4b625b07e6206bbc060baa5489ca17c798df3f9507875f2bf980cbe"
  end

  resource "psutil" do
    url "https://files.pythonhosted.org/packages/fe/69/c0d8e9b9f8a58cbf71aa4cf7f27c27ee0ab05abe32d9157ec22e223edef4/psutil-3.3.0.tar.gz"
    sha256 "421b6591d16b509aaa8d8c15821d66bb94cb4a8dc4385cad5c51b85d4a096d85"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/66/54/d561347dbfa0a1eeaf49a005da5fd71c0a0be8e4e2676f14775dd0097430/python-dateutil-2.3.tar.gz"
    sha256 "2db67d8832f19332908b4b9644865ced34087919702140862093e347e95730e4"
  end

  resource "python-magic" do
    url "https://files.pythonhosted.org/packages/21/57/57c47169c651534014a9852ec690fc0893bab2f67e24d6dab3c945522e7d/python-magic-0.4.6.tar.gz"
    sha256 "903d3d3c676e2b1244892954e2bbbe27871a633385a9bfe81f1a81a7032df2fe"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/0a/00/8cc925deac3a87046a4148d7846b571cf433515872b5430de4cd9dea83cb/requests-2.7.0.tar.gz"
    sha256 "398a3db6d61899d25fd4a06c6ca12051b0ce171d705decd7ed5511517b4bb93d"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/b3/b2/238e2590826bfdd113244a40d9d3eb26918bd798fc187e2360a8367068db/six-1.10.0.tar.gz"
    sha256 "105f8d68616f8248e24bf0e9372ef04d3cc10104f1980f54d57b2ce73a5ad56a"
  end

  resource "ws4py" do
    url "https://files.pythonhosted.org/packages/d6/69/0f5723c5784317278866891546c5fe4521dc404600df504651e9c934fd0d/ws4py-0.3.2.tar.gz"
    sha256 "48a4e005496a60081f74ca130ce55603ff87e1507483535acf902b94761bda8b"
  end

  resource "xattr" do
    url "https://files.pythonhosted.org/packages/c5/80/b25d549ae4bf4f3e9635a331b759ffca2de4dd8a78dc5106d1ca92f5d08d/xattr-0.6.4.tar.gz"
    sha256 "f9dcebc99555634b697fa3dad8ea3047deb389c6f1928d347a0c49277a5c0e9e"
  end

  def install
    # superenv removes -arch flags causing gnureadline to fail
    # See Homebrew/legacy-homebrew#44472
    ENV.permit_arch_flags

    virtualenv_install_with_resources

    # Fix collision between system readline and gnureadline resulting in
    # "incompatible readline module detected (libedit), tab completion disabled"
    # Reported 7 Aug 2016: https://github.com/dnanexus/dx-toolkit/issues/169
    site_packages = libexec/"lib/python2.7/site-packages"
    (site_packages/"homebrew-gnureadline-hack.pth").write <<-EOS.undent
      import sys; import gnureadline; sys.modules["readline"] = gnureadline
    EOS
  end

  test do
    dxenv = <<-EOS.undent
    API server protocol	https
    API server host		api.dnanexus.com
    API server port		443
    Current workspace	None
    Current folder		None
    Current user		None
    EOS
    assert_match dxenv, shell_output("#{bin}/dx env")
  end
end
