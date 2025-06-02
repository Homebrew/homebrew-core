class Pwncat < Formula
  include Language::Python::Virtualenv

  desc "Netcat with FW/IDS/IPS evasion, self-inject-, bind- and reverse shell"
  homepage "https://pwncat.org"
  url "https://files.pythonhosted.org/packages/c9/ce/51f7b53a8ee3b4afe4350577ee92f416f32b9b166f0d84b480fec1717a42/pwncat-0.1.2.tar.gz"
  sha256 "c7f879df3a58bae153b730848a88b0e324c8b7f8c6daa146e67cf45a6c736088"
  license "MIT"
  head "https://github.com/cytopia/pwncat.git", branch: "master"

  bottle do
    rebuild 3
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1971f6379de0d9d4d43605e1cfe6635c966343e2afd1f18e5075059233853433"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1971f6379de0d9d4d43605e1cfe6635c966343e2afd1f18e5075059233853433"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1971f6379de0d9d4d43605e1cfe6635c966343e2afd1f18e5075059233853433"
    sha256 cellar: :any_skip_relocation, sonoma:        "a5c8fa660a7d88d2d31622417ba79e4757c41c2dcf27cebc3a36d26de3eda54b"
    sha256 cellar: :any_skip_relocation, ventura:       "a5c8fa660a7d88d2d31622417ba79e4757c41c2dcf27cebc3a36d26de3eda54b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "681af452580198940fda3bc55892865dd6d9b839ed8a1dcd2b583018bfa43e2c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1971f6379de0d9d4d43605e1cfe6635c966343e2afd1f18e5075059233853433"
  end

  depends_on "python@3.13"

  def install
    virtualenv_install_with_resources
  end

  test do
    system "echo HEAD  | #{bin}/pwncat www.google.com 80 | grep ^HTTP"
  end
end
