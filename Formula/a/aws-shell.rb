class AwsShell < Formula
  include Language::Python::Virtualenv

  desc "Integrated shell for working with the AWS CLI"
  homepage "https://github.com/awslabs/aws-shell"
  url "https://files.pythonhosted.org/packages/01/31/ee166a91c865a855af4f15e393974eadf57762629fc2a163a3eb3f470ac5/aws-shell-0.2.2.tar.gz"
  sha256 "fd1699ea5f201e7cbaacaeb34bf1eb88c8fe6dc6b248bce1b3d22b3e099a41e5"
  license "Apache-2.0"
  revision 7

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "b2184fc10e8b1c76f74026cbbccadfa3543353f733fb728f81b49f5951b4d31c"
    sha256 cellar: :any,                 arm64_sequoia: "c4f93abd6f358455e6ca8d51baf5c2977d622d68a9c2cb7866593381715e31db"
    sha256 cellar: :any,                 arm64_sonoma:  "f76c1b8385bc6312687a8ac90b24b79a78b594272e316877f46572c9aa47a1ac"
    sha256 cellar: :any,                 sonoma:        "d5d93a3c11454b18f29d55ae980862b246326a3d7b31ca951ff7d677de88b66a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "280367d8927e8841423fc16c2882c2d45333ca913f2046200cf1ce76cd93af6d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "32a471c48d1dcf848a13ecc7fec4b8b725f5b352e33d295dfa6905ccdfbb83a3"
  end

  depends_on "libyaml"
  depends_on "python@3.14"

  resource "awscli" do
    url "https://files.pythonhosted.org/packages/2c/f7/b64d6e8e263b9b30da20e3c3a607e887c6ef45aea52aa4142dd7bff2beea/awscli-1.42.55.tar.gz"
    sha256 "547f3e560549358368327423855daea7c007615c9298154a38aa79d647933231"
  end

  resource "boto3" do
    url "https://files.pythonhosted.org/packages/50/d8/a279c054e0c9731172f05b3d118f3ffc9d74806657f84fc0c93c42d1bb5d/boto3-1.40.55.tar.gz"
    sha256 "27e35b4fa9edd414ce06c1a748bf57cacd8203271847d93fc1053e4a4ec6e1a9"
  end

  resource "botocore" do
    url "https://files.pythonhosted.org/packages/a4/92/dce4842b2e215d213d34b064fcdd13c6a782c43344e77336bcde586e9229/botocore-1.40.55.tar.gz"
    sha256 "79b6472e2de92b3519d44fc1eec8c5feced7f99a0d10fdea6dc93133426057c1"
  end

  resource "colorama" do
    url "https://files.pythonhosted.org/packages/d8/53/6f443c9a4a8358a93a6792e2acffb9d9d5cb0a5cfd8802644b7b1c9a02e4/colorama-0.4.6.tar.gz"
    sha256 "08695f5cb7ed6e0531a20572697297273c47b8cae5a63ffc6d6ed5c201be6e44"
  end

  resource "configobj" do
    url "https://files.pythonhosted.org/packages/f5/c4/c7f9e41bc2e5f8eeae4a08a01c91b2aea3dfab40a3e14b25e87e7db8d501/configobj-5.0.9.tar.gz"
    sha256 "03c881bbf23aa07bccf1b837005975993c4ab4427ba57f959afdd9d1a2386848"
  end

  resource "docutils" do
    url "https://files.pythonhosted.org/packages/6b/5c/330ea8d383eb2ce973df34d1239b3b21e91cd8c865d21ff82902d952f91f/docutils-0.19.tar.gz"
    sha256 "33995a6753c30b7f577febfc2c50411fec6aac7f7ffeb7c4cfe5991072dcf9e6"
  end

  resource "jmespath" do
    url "https://files.pythonhosted.org/packages/00/2a/e867e8531cf3e36b41201936b7fa7ba7b5702dbef42922193f05c8976cd6/jmespath-1.0.1.tar.gz"
    sha256 "90261b206d6defd58fdd5e85f478bf633a2901798906be2ad389150c5c60edbe"
  end

  resource "prompt-toolkit" do
    url "https://files.pythonhosted.org/packages/c5/64/c170e5b1913b540bf0c8ab7676b21fdd1d25b65ddeb10025c6ca43cccd4c/prompt_toolkit-1.0.18.tar.gz"
    sha256 "dd4fca02c8069497ad931a2d09914c6b0d1b50151ce876bc15bde4c747090126"
  end

  resource "pyasn1" do
    url "https://files.pythonhosted.org/packages/ba/e9/01f1a64245b89f039897cb0130016d79f77d52669aae6ee7b159a6c4c018/pyasn1-0.6.1.tar.gz"
    sha256 "6f580d2bdd84365380830acf45550f2511469f673cb4a5ae3857a3170128b034"
  end

  resource "pygments" do
    url "https://files.pythonhosted.org/packages/b0/77/a5b8c569bf593b0140bde72ea885a803b82086995367bf2037de0159d924/pygments-2.19.2.tar.gz"
    sha256 "636cb2477cec7f8952536970bc533bc43743542f70392ae026374600add5b887"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/66/c0/0c8b6ad9f17a802ee498c46e004a0eb49bc148f2fd230864601a86dcf6db/python-dateutil-2.9.0.post0.tar.gz"
    sha256 "37dd54208da7e1cd875388217d5e00ebd4179249f90fb72437e91a35459a0ad3"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/05/8e/961c0007c59b8dd7729d542c61a4d537767a59645b82a0b521206e1e25c2/pyyaml-6.0.3.tar.gz"
    sha256 "d76623373421df22fb4cf8817020cbb7ef15c725b9d5e45f17e189bfc384190f"
  end

  resource "rsa" do
    url "https://files.pythonhosted.org/packages/db/b5/475c45a58650b0580421746504b680cd2db4e81bc941e94ca53785250269/rsa-4.7.2.tar.gz"
    sha256 "9d689e6ca1b3038bc82bf8d23e944b6b6037bc02301a574935b2dd946e0353b9"
  end

  resource "s3transfer" do
    url "https://files.pythonhosted.org/packages/62/74/8d69dcb7a9efe8baa2046891735e5dfe433ad558ae23d9e3c14c633d1d58/s3transfer-0.14.0.tar.gz"
    sha256 "eff12264e7c8b4985074ccce27a3b38a485bb7f7422cc8046fee9be4983e4125"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/94/e7/b2c673351809dca68a0e064b6af791aa332cf192da575fd474ed7d6f16a2/six-1.17.0.tar.gz"
    sha256 "ff70335d468e7eb6ec65b95b99d3a2836546063f63acc5171de367e834932a81"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/15/22/9ee70a2574a4f4599c47dd506532914ce044817c7752a79b6a51286319bc/urllib3-2.5.0.tar.gz"
    sha256 "3fc47733c7e419d4bc3f6b3dc2b4f890bb743906a30d56ba4a5bfa4bbff92760"
  end

  resource "wcwidth" do
    url "https://files.pythonhosted.org/packages/24/30/6b0809f4510673dc723187aeaf24c7f5459922d01e2f794277a3dfb90345/wcwidth-0.2.14.tar.gz"
    sha256 "4d478375d31bc5395a3c55c40ccdf3354688364cd61c4f6adacaa9215d0b3605"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    system bin/"aws-shell", "--help"
  end
end
