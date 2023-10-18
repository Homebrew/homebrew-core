class Mackup < Formula
  include Language::Python::Virtualenv

  desc "Keep your Mac's application settings in sync"
  homepage "https://github.com/lra/mackup"
  url "https://files.pythonhosted.org/packages/a1/9e/3aa16b0ce9de5da853b3c273a4595f607781d649e3c6fe8740eab3b2ff99/mackup-0.8.37.tar.gz"
  sha256 "7e86c3bc427f4ec4be56b23a225a9f1482fb2aeb917e4240f7fb9f54626f32d6"
  license "GPL-3.0-or-later"
  head "https://github.com/lra/mackup.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c885aa3f8a09bbf8954f026258bc15dfaee2d3a3867cf1b3e1351f4baad15bd7"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "738d76ca5edd2b6b9a9cf8d9628db247e03cbb0c58b699e829fce4ae23279e7b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e8372ffdc667a42fd5a91734c05e1c197b9464fc6208aca62b6455fcec755677"
    sha256 cellar: :any_skip_relocation, sonoma:         "f4b728be8a16795913f702df6116359ee8704e7f6b7bef483536ec2f86765e49"
    sha256 cellar: :any_skip_relocation, ventura:        "90d3eb5af832b27058d373a40fbaa1c8079aa1b9537e73906703b9ad2485e61c"
    sha256 cellar: :any_skip_relocation, monterey:       "2c28f1db3fad2ea4bcf1547ffd9ca02bc04dc3a5d9726ad789d2558a69b5145a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "72757b195e58f5cca75b4de5226db8b74c6c711966f463cd3cc6c928b2cf636b"
  end

  depends_on "python@3.12"
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
