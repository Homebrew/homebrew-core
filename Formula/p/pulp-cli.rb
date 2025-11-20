class PulpCli < Formula
  include Language::Python::Virtualenv

  desc "Command-line interface for Pulp 3"
  homepage "https://github.com/pulp/pulp-cli"
  url "https://files.pythonhosted.org/packages/e8/d6/12f647c25d1043443574c75a93808288775b037b274847b8e1dd75e3e527/pulp_cli-0.36.2.tar.gz"
  sha256 "a944189397a9130bb96fce682cf1135d8f9e0e16fd8af31c5a14f958443c69e0"
  license "GPL-2.0-or-later"
  head "https://github.com/pulp/pulp-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "a947851de0e20f8afe493272d16094e375faf3e51b1581fd4a36d3b83652fd83"
    sha256 cellar: :any,                 arm64_sequoia: "830934630031f4d53f04ca772f49e9b2f0f2e88dd530d74e09bff21a9cbb245d"
    sha256 cellar: :any,                 arm64_sonoma:  "822cc7c34ad5abce7475ba5a651e05dc9340be4f39eb23d1a9620075ec8e084b"
    sha256 cellar: :any,                 sonoma:        "ec62d4a8a143911114e6f6dae3d3c792042ba9c8ee80d68e60a0eed71b6f83fa"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "efcf85ea2301210fe7f8fdc6de6cfbf2daa5cc3c4b2088a39c091932b90c6dad"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "47a679c015a2c202c317e10b4b25246339f1002224b59ebe2320675320895897"
  end

  depends_on "certifi" => :no_linkage
  depends_on "libyaml"
  depends_on "python@3.14"

  pypi_packages exclude_packages: "certifi"

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/13/69/33ddede1939fdd074bce5434295f38fae7136463422fe4fd3e0e89b98062/charset_normalizer-3.4.4.tar.gz"
    sha256 "94537985111c35f28720e43603b8e7b43a6ecfb2ce1d3058bbe955b73404e21a"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/46/61/de6cd827efad202d7057d93e0fed9294b96952e188f7384832791c7b2254/click-8.3.0.tar.gz"
    sha256 "e7b8232224eba16f4ebe410c25ced9f7875cb5f3263ffc93cc3e8da705e229c4"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/6f/6d/0703ccc57f3a7233505399edb88de3cbd678da106337b9fcde432b65ed60/idna-3.11.tar.gz"
    sha256 "795dafcc9c04ed0c1fb032c2aa73654d8e8c5023a7df64a53f39190ada629902"
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
    url "https://files.pythonhosted.org/packages/bd/f6/308b7c779d382c3fe8e3ae9c945947ee7066874ca417c1f6db2123a18301/pulp_glue-0.36.2.tar.gz"
    sha256 "6af07f0e6b7d1953876ff987c303d17082d094038ad4263d21c2c936d4ed7479"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/05/8e/961c0007c59b8dd7729d542c61a4d537767a59645b82a0b521206e1e25c2/pyyaml-6.0.3.tar.gz"
    sha256 "d76623373421df22fb4cf8817020cbb7ef15c725b9d5e45f17e189bfc384190f"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/c9/74/b3ff8e6c8446842c3f5c837e9c3dfcfe2018ea6ecef224c710c85ef728f4/requests-2.32.5.tar.gz"
    sha256 "dbba0bac56e100853db0ea71b82b4dfd5fe2bf6d3754a8893c3af500cec7d7cf"
  end

  resource "schema" do
    url "https://files.pythonhosted.org/packages/fb/2e/8da627b65577a8f130fe9dfa88ce94fcb24b1f8b59e0fc763ee61abef8b8/schema-0.7.8.tar.gz"
    sha256 "e86cc08edd6fe6e2522648f4e47e3a31920a76e82cce8937535422e310862ab5"
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
