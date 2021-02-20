class Parliament < Formula
  include Language::Python::Virtualenv

  desc "AWS IAM linting library"
  homepage "https://github.com/duo-labs/parliament"
  url "https://files.pythonhosted.org/packages/7e/82/26b58070877848c21c59a7c8325117941ec136552425212daa0968e8afcd/parliament-1.3.1.tar.gz"
  sha256 "2359299fb09a495faee2622c03c6d3765660656fbc0a4f197c309dbd7a6e2ba6"
  license "BSD-3-Clause"
  head "https://github.com/duo-labs/parliament.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "9f70cf3b6423e91652f08b3698aab86e20f0a9d0e6cd652f736374eb4b1d0127"
    sha256 cellar: :any_skip_relocation, big_sur:       "c1d1332ba7011cc681f59ee95fe6af042b2baf9b26a12e6acd967312708c78ee"
    sha256 cellar: :any_skip_relocation, catalina:      "8055e860ac18dc826c696a9a8f81360f9aef83f5118cadb4ab25139aae9f87f9"
    sha256 cellar: :any_skip_relocation, mojave:        "fa8639a7909372ac5aa3c4a7131af57cea5589f99443a0a0f819f5789b383876"
  end

  depends_on "python@3.9"

  resource "boto3" do
    url "https://files.pythonhosted.org/packages/e4/00/a0e3d95ecbd78f3a7bc89cce4c94c2fca4820536f513bf8aba35b36bb79b/boto3-1.16.59.tar.gz"
    sha256 "550a513315194292651bb6cc96e94185bfc4dc6b299c3cf1594882bdd16b3905"
  end

  resource "botocore" do
    url "https://files.pythonhosted.org/packages/b9/87/c28866fd15cb87d893048ff16d08b179db9a1b8f5119c22562b564ff59ad/botocore-1.19.59.tar.gz"
    sha256 "33959aa19cb6d336c47495c871b00d8670de0023b53bbbbd25790ba0bc5cefe9"
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
    url "https://files.pythonhosted.org/packages/29/e6/d1a1d78c439cad688757b70f26c50a53332167c364edb0134cadd280e234/urllib3-1.26.2.tar.gz"
    sha256 "19188f96923873c92ccb987120ec4acaa12f0461fa9ce5d3d0772bc965a39e08"
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
