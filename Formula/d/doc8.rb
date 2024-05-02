class Doc8 < Formula
  include Language::Python::Virtualenv

  desc "Style checker for Sphinx documentation"
  homepage "https://github.com/PyCQA/doc8"
  url "https://files.pythonhosted.org/packages/a1/b5/63a2f2ceba95be5cc15813fd310d560264e8662dbd7495669a1e26d59026/doc8-1.1.1.tar.gz"
  sha256 "d97a93e8f5a2efc4713a0804657dedad83745cca4cd1d88de9186f77f9776004"
  license "Apache-2.0"
  head "https://github.com/PyCQA/doc8.git", branch: "main"

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "19afe5fe6d519aa6f95b9bfcdc03217d80e1eef12845f1cf4a6df6666dd13be0"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "34c2af1d4bcaceda69f99623f6477f10338e6c7bfae75e4747a761d4e27d9c01"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f243afe79d6c21dc8bdec9cb3dec2fe28844b7f9dd7540f2d361b98e4603f3af"
    sha256 cellar: :any_skip_relocation, sonoma:         "97589fd0e5a9ff1e28462a7f57dbb74cadbc8f50fa665972c7dac7e6a70ea2fa"
    sha256 cellar: :any_skip_relocation, ventura:        "fa252efb596300267b70559c70d5f9ee051303ddb8d1f96e36d6491b6ffeeb97"
    sha256 cellar: :any_skip_relocation, monterey:       "b87a1b15782d7290d386fae72081a3b2f1629cb276aa5292710940c31b794ef8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0be4c5cee6cd61e606a920a4803c9dbe4ca30c65b340679408d5f579a4219f29"
  end

  depends_on "python@3.12"

  resource "docutils" do
    url "https://files.pythonhosted.org/packages/1f/53/a5da4f2c5739cf66290fac1431ee52aff6851c7c8ffd8264f13affd7bcdd/docutils-0.20.1.tar.gz"
    sha256 "f08a4e276c3a1583a86dce3e34aba3fe04d02bba2dd51ed16106244e8a923e3b"
  end

  resource "pbr" do
    url "https://files.pythonhosted.org/packages/8d/c2/ee43b3b11bf2b40e56536183fc9f22afbb04e882720332b6276ee2454c24/pbr-6.0.0.tar.gz"
    sha256 "d1377122a5a00e2f940ee482999518efe16d745d423a670c27773dfbc3c9a7d9"
  end

  resource "pygments" do
    url "https://files.pythonhosted.org/packages/55/59/8bccf4157baf25e4aa5a0bb7fa3ba8600907de105ebc22b0c78cfbf6f565/pygments-2.17.2.tar.gz"
    sha256 "da46cec9fd2de5be3a8a784f434e4c4ab670b4ff54d605c4c2717e9d49c4c367"
  end

  resource "restructuredtext-lint" do
    url "https://files.pythonhosted.org/packages/48/9c/6d8035cafa2d2d314f34e6cd9313a299de095b26e96f1c7312878f988eec/restructuredtext_lint-1.4.0.tar.gz"
    sha256 "1b235c0c922341ab6c530390892eb9e92f90b9b75046063e047cacfb0f050c45"
  end

  resource "stevedore" do
    url "https://files.pythonhosted.org/packages/ac/d6/77387d3fc81f07bc8877e6f29507bd7943569093583b0a07b28cfa286780/stevedore-5.1.0.tar.gz"
    sha256 "a54534acf9b89bc7ed264807013b505bf07f74dbe4bcfa37d32bd063870b087c"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    (testpath/"broken.rst").write <<~EOS
      Heading
      ------
    EOS
    output = pipe_output("#{bin}/doc8 broken.rst 2>&1")
    assert_match "D000 Title underline too short.", output
  end
end
