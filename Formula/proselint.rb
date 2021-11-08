class Proselint < Formula
  include Language::Python::Virtualenv

  desc "Linter for prose"
  homepage "http://proselint.com"
  url "https://files.pythonhosted.org/packages/a2/be/2c1bcc43d85b23fe97dae02efd3e39b27cd66cca4a9f9c70921718b74ac2/proselint-0.13.0.tar.gz"
  sha256 "7dd2b63cc2aa390877c4144fcd3c80706817e860b017f04882fbcd2ab0852a58"
  license "BSD-3-Clause"
  head "https://github.com/amperser/proselint.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b6bc3c6d815d17f91c0fa132beeff0ff83cc92ae0b3d63cec8614847765cbc27"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d0b1ed00f35f99465b9781023fd59af96e986bc46b5cba41247cc70cbbe64f0d"
    sha256 cellar: :any_skip_relocation, monterey:       "6e3b7e9089b83ab06c70d14df7adc58a5fc5af942e7e1d5afa8db9c06514866d"
    sha256 cellar: :any_skip_relocation, big_sur:        "3a3865b2a11e676c91cab82ca02d9a5b1f7f7f2aeec309cfd85e065387ce2999"
    sha256 cellar: :any_skip_relocation, catalina:       "adb95b9a130c0e44115b9e05b012be58870b56416189cfcf2bc02ebfb04f695a"
    sha256 cellar: :any_skip_relocation, mojave:         "b2bc217150a230017811eb50ae36d85c812b44850afb6e60e5895d57c0ac9cca"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ee110a0d127db7fe91ce694498faaf1a8834d1f32688c9a33274f40434e35c0c"
  end

  depends_on "python@3.9"
  depends_on "six"

  resource "click" do
    url "https://files.pythonhosted.org/packages/f4/09/ad003f1e3428017d1c3da4ccc9547591703ffea548626f47ec74509c5824/click-8.0.3.tar.gz"
    sha256 "410e932b050f5eed773c4cda94de75971c89cdb3155a72a0831139a79e5ecb5b"
  end

  resource "future" do
    url "https://files.pythonhosted.org/packages/45/0b/38b06fd9b92dc2b68d58b75f900e97884c45bedd2ff83203d933cf5851c9/future-0.18.2.tar.gz"
    sha256 "b1bead90b70cf6ec3f0710ae53a525360fa360d306a86583adc6bf83a4db537d"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    output = pipe_output("#{bin}/proselint --compact -", "John is very unique.")
    assert_match "Comparison of an uncomparable", output
  end
end
