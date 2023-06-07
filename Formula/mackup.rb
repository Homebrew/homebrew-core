class Mackup < Formula
  include Language::Python::Virtualenv

  desc "Keep your Mac's application settings in sync"
  homepage "https://github.com/lra/mackup"
  url "https://files.pythonhosted.org/packages/a1/9e/3aa16b0ce9de5da853b3c273a4595f607781d649e3c6fe8740eab3b2ff99/mackup-0.8.37.tar.gz"
  sha256 "7e86c3bc427f4ec4be56b23a225a9f1482fb2aeb917e4240f7fb9f54626f32d6"
  license "GPL-3.0-or-later"
  head "https://github.com/lra/mackup.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "622d8ab1fbca9d7f8a91d500e9cdfda730a20db04f93951a04bb349973d209ef"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "622d8ab1fbca9d7f8a91d500e9cdfda730a20db04f93951a04bb349973d209ef"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "622d8ab1fbca9d7f8a91d500e9cdfda730a20db04f93951a04bb349973d209ef"
    sha256 cellar: :any_skip_relocation, ventura:        "2040dc49fc1e8ca1ebba28ab8b9d18b6e2c7c5acc6ba9ed54b5ab7a79442a0da"
    sha256 cellar: :any_skip_relocation, monterey:       "2040dc49fc1e8ca1ebba28ab8b9d18b6e2c7c5acc6ba9ed54b5ab7a79442a0da"
    sha256 cellar: :any_skip_relocation, big_sur:        "2040dc49fc1e8ca1ebba28ab8b9d18b6e2c7c5acc6ba9ed54b5ab7a79442a0da"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d8a14270ae10d3498bddea759d152b70a333b614f894fcf3d1e23622f2dc695c"
  end

  depends_on "python@3.11"
  depends_on "six"

  resource "docopt" do
    url "https://files.pythonhosted.org/packages/a2/55/8f8cab2afd404cf578136ef2cc5dfb50baa1761b68c9da1fb1e4eed343c9/docopt-0.6.2.tar.gz"
    sha256 "49b3a825280bd66b3aa83585ef59c4a8c82f2c8a522dbe754a8bc8d08c85c491"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    system "#{bin}/mackup", "--help"
  end
end
