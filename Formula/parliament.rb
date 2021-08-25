class Parliament < Formula
  include Language::Python::Virtualenv

  desc "AWS IAM linting library"
  homepage "https://github.com/duo-labs/parliament"
  url "https://files.pythonhosted.org/packages/1a/29/e8c814819571c78c1f1e25dbe20f995fb86b854aa59db4fbab20a641a346/parliament-1.4.0.tar.gz"
  sha256 "cf40d5f5732bcf831fdb1a13f71c3cf4f3bdb8c8d9685592ecdd6d84675b947e"
  license "BSD-3-Clause"
  head "https://github.com/duo-labs/parliament.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "70152e9beb86b2ee8e3e167abb8eb11afabff2834021ac3a13ead2833f78b018"
    sha256 cellar: :any_skip_relocation, big_sur:       "055f7fefb957c5269ab8ec19654b06e0e7db865333bbebb62a5e2ea9940ddfca"
    sha256 cellar: :any_skip_relocation, catalina:      "b29b423794a9ccb15f1509f6086b170f4f3393bad15a8bdaa9ab7312fc09ae31"
    sha256 cellar: :any_skip_relocation, mojave:        "2e59a17e90ad49204bd45177cddf947bd1fda2405572ae62b194143bb9cab337"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7b49f599b5b557d4fb45bdaed4f874f70bedaba7f087ee3ec851d4cd44b29edd"
  end

  depends_on "python@3.9"

  resource "boto3" do
    url "https://files.pythonhosted.org/packages/f4/ba/150dd700298b386152dc17582f4d62b0ccd1cb0431a6f0bb63c37cb76b8a/boto3-1.17.29.tar.gz"
    sha256 "31396fcaffdfc0f465b4de76e1ecae53894eb869b000ffa54aa1693a98db3a3c"
  end

  resource "botocore" do
    url "https://files.pythonhosted.org/packages/d3/9b/98602d3e056a4294e05ff46d21a6fd44c2f4f310e057c711010f6eb5817f/botocore-1.20.29.tar.gz"
    sha256 "184b7d26b0669fd65ac8193662376d1267d800e005b69412b57cc82c5ffbe935"
  end

  resource "jmespath" do
    url "https://files.pythonhosted.org/packages/3c/56/3f325b1eef9791759784aa5046a8f6a1aff8f7c898a2e34506771d3b99d8/jmespath-0.10.0.tar.gz"
    sha256 "b85d0567b8666149a93172712e68920734333c0ce7e89b78b3e987f71e5ed4f9"
  end

  resource "json-cfg" do
    url "https://files.pythonhosted.org/packages/70/d8/34e37fb051be7c3b143bdb3cc5827cb52e60ee1014f4f18a190bb0237759/json-cfg-0.4.2.tar.gz"
    sha256 "d3dd1ab30b16a3bb249b6eb35fcc42198f9656f33127e36a3fadb5e37f50d45b"
  end

  resource "kwonly-args" do
    url "https://files.pythonhosted.org/packages/ee/da/a7ba4f2153a536a895a9d29a222ee0f138d617862f9b982bd4ae33714308/kwonly-args-1.0.10.tar.gz"
    sha256 "59c85e1fa626c0ead5438b64f10b53dda2459e0042ea24258c9dc2115979a598"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/be/ed/5bbc91f03fa4c839c4c7360375da77f9659af5f7086b7a7bdda65771c8e0/python-dateutil-2.8.1.tar.gz"
    sha256 "73ebfe9dbf22e832286dafa60473e4cd239f8592f699aa5adaf10050e6e1823c"
  end

  resource "PyYAML" do
    url "https://files.pythonhosted.org/packages/a0/a4/d63f2d7597e1a4b55aa3b4d6c5b029991d3b824b5bd331af8d4ab1ed687d/PyYAML-5.4.1.tar.gz"
    sha256 "607774cbba28732bfa802b54baa7484215f530991055bb562efbed5b2f20a45e"
  end

  resource "s3transfer" do
    url "https://files.pythonhosted.org/packages/08/e1/3ee2096ebaeeb8c186d20ed16c8faf4a503913e5c9a0e14cd6b8ffc405a3/s3transfer-0.3.4.tar.gz"
    sha256 "7fdddb4f22275cf1d32129e21f056337fd2a80b6ccef1664528145b72c49e6d2"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/6b/34/415834bfdafca3c5f451532e8a8d9ba89a21c9743a0c59fbd0205c7f9426/six-1.15.0.tar.gz"
    sha256 "30639c035cdb23534cd4aa2dd52c3bf48f06e5f4a941509c8bafd8ce11080259"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/cb/cf/871177f1fc795c6c10787bc0e1f27bb6cf7b81dbde399fd35860472cecbc/urllib3-1.26.4.tar.gz"
    sha256 "e7b021f7241115872f92f43c6508082facffbd1c048e3c6e2bb9c2a157e28937"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_equal "MEDIUM - No resources match for the given action -  - [{'action': 's3:GetObject',"\
                 " 'required_format': 'arn:*:s3:::*/*'}] - {'line': 1, 'column': 40, 'filepath': None}", \
    pipe_output("#{bin}/parliament --string \'{\"Version\": \"2012-10-17\", \"Statement\": {\"Effect\": \"Allow\","\
                " \"Action\": \"s3:GetObject\", \"Resource\": \"arn:aws:s3:::secretbucket\"}}\'").strip
  end
end
