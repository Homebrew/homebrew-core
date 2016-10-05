require "utils/json"

class Internetarchive < Formula
  include Language::Python::Virtualenv

  desc "Python wrapper for the various Internet Archive APIs"
  homepage "https://github.com/jjjake/internetarchive"
  url "https://pypi.python.org/packages/3e/e3/fd6d8c7dafef90d7be5ec6216fd0b352d130f4accee7598cc6a10e85e141/internetarchive-1.0.10.tar.gz"
  sha256 "a376762c7335db422f7a6691ed037bca5567f293ea244a12f2910e25ff9a550d"

  bottle do
    cellar :any_skip_relocation
    sha256 "1c4e832ace5b621f51c63e5a0fe430206ce8e020888b06f25a43fcc4c3ce15df" => :sierra
    sha256 "8ce2a4a316f80a828d5b4ba9bcb4155de4143d8ac4add7b5ff2d3f7c8e288879" => :el_capitan
    sha256 "77ff6084b75f58e4ad30ef081bab59d4418ca8d9133e18bdc2d868c6fa1557e2" => :yosemite
  end

  resource "args" do
    url "https://files.pythonhosted.org/packages/e5/1c/b701b3f4bd8d3667df8342f311b3efaeab86078a840fb826bd204118cc6b/args-0.1.0.tar.gz"
    sha256 "a785b8d837625e9b61c39108532d95b85274acd679693b71ebb5156848fcf814"
  end

  resource "clint" do
    url "https://files.pythonhosted.org/packages/3d/b4/41ecb1516f1ba728f39ee7062b9dac1352d39823f513bb6f9e8aeb86e26d/clint-0.5.1.tar.gz"
    sha256 "05224c32b1075563d0b16d0015faaf9da43aa214e4a2140e51f08789e7a4c5aa"
  end

  resource "docopt" do
    url "https://files.pythonhosted.org/packages/a2/55/8f8cab2afd404cf578136ef2cc5dfb50baa1761b68c9da1fb1e4eed343c9/docopt-0.6.2.tar.gz"
    sha256 "49b3a825280bd66b3aa83585ef59c4a8c82f2c8a522dbe754a8bc8d08c85c491"
  end

  resource "jsonpatch" do
    url "https://pypi.python.org/packages/source/j/jsonpatch/jsonpatch-0.4.tar.gz"
    sha256 "43d725fb21d31740b4af177d482d9ae53fe23daccb13b2b7da2113fe80b3191e"
  end

  resource "jsonpointer" do
    url "https://files.pythonhosted.org/packages/f6/36/6bdd302303e8bc7c25102dbc1eabb3e3d97f57b0f8f414f4da7ea7ab9dd8/jsonpointer-1.10.tar.gz"
    sha256 "9fa5dcac35eefd53e25d6cd4c310d963c9f0b897641772cd6e5e7b89df7ee0b1"
  end

  resource "PyYAML" do
    url "https://files.pythonhosted.org/packages/4a/85/db5a2df477072b2902b0eb892feb37d88ac635d36245a72a6a69b23b383a/PyYAML-3.12.tar.gz"
    sha256 "592766c6303207a20efc445587778322d7f73b161bd994f227adaa341ba212ab"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/49/6f/183063f01aae1e025cf0130772b55848750a2f3a89bfa11b385b35d7329d/requests-2.10.0.tar.gz"
    sha256 "63f1815788157130cee16a933b2ee184038e975f0017306d723ac326b5525b54"
  end

  resource "schema" do
    url "https://files.pythonhosted.org/packages/b0/41/68972daad372fff3a2381e0416ff704faf524b2974e01d1c4fc997b4fb39/schema-0.4.0.tar.gz"
    sha256 "63f3ed23f3c383203bdac0c9a4c1fa823a507c3bfcd555954367a20a1c294973"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/b3/b2/238e2590826bfdd113244a40d9d3eb26918bd798fc187e2360a8367068db/six-1.10.0.tar.gz"
    sha256 "105f8d68616f8248e24bf0e9372ef04d3cc10104f1980f54d57b2ce73a5ad56a"
  end

  def install
    # Required with Apple clang 7.0.0+/LLVM clang 3.6.0+ for gevent < 1.1.
    ENV.append "CFLAGS", "-std=gnu99" if ENV.compiler == :clang

    virtualenv_install_with_resources
  end

  test do
    metadata = Utils::JSON.load shell_output("#{bin}/ia metadata tigerbrew")
    assert_equal metadata["metadata"]["uploader"], "mistydemeo@gmail.com"
  end
end
