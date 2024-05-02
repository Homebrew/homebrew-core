class Pwncat < Formula
  include Language::Python::Virtualenv

  desc "Netcat with FW/IDS/IPS evasion, self-inject-, bind- and reverse shell"
  homepage "https://pwncat.org"
  url "https://files.pythonhosted.org/packages/c9/ce/51f7b53a8ee3b4afe4350577ee92f416f32b9b166f0d84b480fec1717a42/pwncat-0.1.2.tar.gz"
  sha256 "c7f879df3a58bae153b730848a88b0e324c8b7f8c6daa146e67cf45a6c736088"
  license "MIT"
  head "https://github.com/cytopia/pwncat.git", branch: "master"

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "95a9144357872cec420346ef47d347a13d30d9b767e60c941280cedc60d4652b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "92a2fef2c1bb154344c8210db3deba312f09196fd049f3b85340eaaf64004161"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e0e0fcc582ecfab9b83dd6133a4b7fc7babc5e9c11c0b4901addf6318c95ebf0"
    sha256 cellar: :any_skip_relocation, sonoma:         "32e7923256b8376b1b12c17baead045088d5dd673fed9312efcb376ab9d3891c"
    sha256 cellar: :any_skip_relocation, ventura:        "2df07db261c989e405811f5f0fc6444d6c214aa946ad0cfdfedd1a3fa8b77ba3"
    sha256 cellar: :any_skip_relocation, monterey:       "7e3e61903889837ca811fdea837ed305579a2fb63203b3fa947f899d46883b88"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3d39c0f3640c1eed898b0e5a509933b37978ec04d609d28135064bc9573a8313"
  end

  depends_on "python@3.12"

  def install
    virtualenv_install_with_resources
  end

  test do
    system "echo HEAD  | #{bin}/pwncat www.google.com 80 | grep ^HTTP"
  end
end
