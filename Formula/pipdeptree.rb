class Pipdeptree < Formula
  include Language::Python::Virtualenv

  desc "CLI to display dependency tree of the installed Python packages"
  homepage "https://github.com/tox-dev/pipdeptree"
  url "https://files.pythonhosted.org/packages/24/e1/6487323228477c0f68ea1f853ff78e9909736d209fdc38351d2772ca0346/pipdeptree-2.9.0.tar.gz"
  sha256 "b2e89d19b832f40c19e124a81857c1a4c313cd601e32300ea837ba4797ef9af3"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4eec3e74773daa93697551ddfe7917064ea4d58294f1907e57cab15e81019cb7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1a928314c4a3917a4e11bd25177d4c41f9a5bcb6afa378a2b7637d0ffa21da5f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5521d5fbe0b0d535c2ad2ed1f5c9ca2eec381eb1f2b251ef7da7eba48079432c"
    sha256 cellar: :any_skip_relocation, ventura:        "4f501dd8f2facf9d4ecc959f20a97efd9d0b574a8e797645f2176a3837dcf24f"
    sha256 cellar: :any_skip_relocation, monterey:       "4fc8972e264709fe6d3fe8f32db734a0ede42db411933dfd31ffbe8b1d8e909f"
    sha256 cellar: :any_skip_relocation, big_sur:        "51101a40e24ed1eb1e0e77394c6904247d0ac765e61b9df1cc8fa5c844304654"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f851128c362e73b63d524b6a3ea2cfcf206587a24636a88d88a005749d9f0fde"
  end

  depends_on "python@3.11"

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match "pipdeptree==#{version}", shell_output("#{bin}/pipdeptree --all")

    assert_empty shell_output("#{bin}/pipdeptree --user-only").strip

    assert_equal version.to_s, shell_output("#{bin}/pipdeptree --version").strip
  end
end
