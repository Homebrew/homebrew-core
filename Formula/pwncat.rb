class Pwncat < Formula
  include Language::Python::Virtualenv

  desc "Netcat with FW/IDS/IPS evasion, self-inject-, bind- and reverse shell"
  homepage "https://pwncat.org"
  url "https://files.pythonhosted.org/packages/c9/ce/51f7b53a8ee3b4afe4350577ee92f416f32b9b166f0d84b480fec1717a42/pwncat-0.1.2.tar.gz"
  sha256 "c7f879df3a58bae153b730848a88b0e324c8b7f8c6daa146e67cf45a6c736088"
  license "MIT"
  head "https://github.com/cytopia/pwncat.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "13ef41fbecdf01f47064a3e29ce0ac70a4bfa0110e1dbc2cb5d6cd09a187642a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "13ef41fbecdf01f47064a3e29ce0ac70a4bfa0110e1dbc2cb5d6cd09a187642a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "13ef41fbecdf01f47064a3e29ce0ac70a4bfa0110e1dbc2cb5d6cd09a187642a"
    sha256 cellar: :any_skip_relocation, ventura:        "28c110818dc6d9aa1a4c6a06376f5c66dfc485a6f74c21f94dd207ac6b1f2e39"
    sha256 cellar: :any_skip_relocation, monterey:       "28c110818dc6d9aa1a4c6a06376f5c66dfc485a6f74c21f94dd207ac6b1f2e39"
    sha256 cellar: :any_skip_relocation, big_sur:        "28c110818dc6d9aa1a4c6a06376f5c66dfc485a6f74c21f94dd207ac6b1f2e39"
    sha256 cellar: :any_skip_relocation, catalina:       "28c110818dc6d9aa1a4c6a06376f5c66dfc485a6f74c21f94dd207ac6b1f2e39"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0c5614f155b08f02b5446436dabdffba7dcaa6b7e850c7a237ffd2fb8b970970"
  end

  depends_on "python@3.11"

  def install
    virtualenv_install_with_resources
  end

  test do
    system "echo HEAD  | #{bin}/pwncat www.google.com 80 | grep ^HTTP"
  end
end
