class PulpCli < Formula
  include Language::Python::Virtualenv

  desc "Command-line interface for Pulp 3"
  homepage "https://github.com/pulp/pulp-cli"
  url "https://files.pythonhosted.org/packages/18/92/23ae95fa65ad1f61cb1e7b8140a7aa315c9ad9cc64f2c7fc9412ba1299f2/pulp-cli-0.36.0.tar.gz"
  sha256 "1155a3d7efb60c3c1b0b2762b989fa0616e8a941a878f5e1f1fe0ce207eb05c1"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "70bee84cde5f41f012f3f20adbe663d1ca3064141985171889b7d012bf7b3e18"
    sha256 cellar: :any,                 arm64_sequoia: "a541d3b1434eb9c01d4d87fd7dee1abd934f10d034079aa0a22f6dbb38779178"
    sha256 cellar: :any,                 arm64_sonoma:  "935c3ee12f46129e537691d8e14e8a89d21e1507f6b9e34fb6583798465bfdca"
    sha256 cellar: :any,                 arm64_ventura: "e6ea4509d7a87d0eb1a54d24fd5689a6a40b2a101fb94ac3e87111a1b21401c6"
    sha256 cellar: :any,                 sonoma:        "f77c6beb7cf77053ed878be4650d28e23049261cd136775d17c59c298c39876f"
    sha256 cellar: :any,                 ventura:       "5f8477a68c944547efe69138704660a7ba9fec99398ca404617697d308ba7dec"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "45b625bd32427fac9b6a556c077d7704f11ccaf7c67c821d087b7b3d10932bb9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c9a7383f097564bdaee324749555421b7240516dfef19c499f70fa10769d877c"
  end

  depends_on "certifi"
  depends_on "libyaml"
  depends_on "python@3.13"

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/83/2d/5fd176ceb9b2fc619e63405525573493ca23441330fcdaee6bef9460e924/charset_normalizer-3.4.3.tar.gz"
    sha256 "6fce4b8500244f6fcb71465d4a4930d132ba9ab8e71a7859e6a5d59851068d14"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/60/6c/8ca2efa64cf75a977a0d7fac081354553ebe483345c734fb6b6515d96bbc/click-8.2.1.tar.gz"
    sha256 "27c491cc05d968d271d5a1db13e3b5a184636d9d930f148c50b038f0d0646202"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/f1/70/7703c29685631f5a7590aa73f1f1d3fa9a380e654b86af429e0934a32f7d/idna-3.10.tar.gz"
    sha256 "12f65c9b470abda6dc35cf8e63cc574b1c52b11df2c86030af0ac09b01b13ea9"
  end

  resource "multidict" do
    url "https://files.pythonhosted.org/packages/69/7f/0652e6ed47ab288e3756ea9c0df8b14950781184d4bd7883f4d87dd41245/multidict-6.6.4.tar.gz"
    sha256 "d2d4e4787672911b48350df02ed3fa3fffdc2f2e8ca06dd6afdf34189b76a9dd"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/a1/d4/1fc4078c65507b51b96ca8f8c3ba19e6a61c8253c72794544580a7b6c24d/packaging-25.0.tar.gz"
    sha256 "d443872c98d677bf60f6a1f2f8c1cb748e8fe762d2bf9d3148b5599295b0fc4f"
  end

  resource "pulp-glue" do
    url "https://files.pythonhosted.org/packages/b7/6d/d8bac57d69902a0836f1d5be9ebf14da4c401b638913a393725cadfe3fc0/pulp-glue-0.36.0.tar.gz"
    sha256 "627f6b42a612c4542850a9b5719255373c2399565c779a78d5468378ea584b7c"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/54/ed/79a089b6be93607fa5cdaedf301d7dfb23af5f25c398d5ead2525b063e17/pyyaml-6.0.2.tar.gz"
    sha256 "d584d9ec91ad65861cc08d42e834324ef890a082e591037abe114850ff7bbc3e"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/c9/74/b3ff8e6c8446842c3f5c837e9c3dfcfe2018ea6ecef224c710c85ef728f4/requests-2.32.5.tar.gz"
    sha256 "dbba0bac56e100853db0ea71b82b4dfd5fe2bf6d3754a8893c3af500cec7d7cf"
  end

  resource "schema" do
    url "https://files.pythonhosted.org/packages/d4/01/0ea2e66bad2f13271e93b729c653747614784d3ebde219679e41ccdceecd/schema-0.7.7.tar.gz"
    sha256 "7da553abd2958a19dc2547c388cde53398b39196175a9be59ea1caf5ab0a1807"
  end

  resource "tomli-w" do
    url "https://files.pythonhosted.org/packages/19/75/241269d1da26b624c0d5e110e8149093c759b7a286138f4efd61a60e75fe/tomli_w-1.2.0.tar.gz"
    sha256 "2dd14fac5a47c27be9cd4c976af5a12d87fb1f0b4512f81d69cce3b35ae25021"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/15/22/9ee70a2574a4f4599c47dd506532914ce044817c7752a79b6a51286319bc/urllib3-2.5.0.tar.gz"
    sha256 "3fc47733c7e419d4bc3f6b3dc2b4f890bb743906a30d56ba4a5bfa4bbff92760"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/pulp --version")

    (testpath/"config.toml").write <<~TEXT
      [cli]
      base_url = "https://pulp.dev"
      verify_ssl = false
      format = "json"
    TEXT

    output = shell_output("#{bin}/pulp config validate --location #{testpath}/config.toml")
    assert_match "valid pulp-cli config", output
  end
end
