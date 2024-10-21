class Pipdeptree < Formula
  include Language::Python::Virtualenv

  desc "CLI to display dependency tree of the installed Python packages"
  homepage "https://github.com/tox-dev/pipdeptree"
  url "https://files.pythonhosted.org/packages/66/b6/389a1148d7b1bc5638d4e9b2d60390f8cfb4c30e34cff68165cbd9a29e75/pipdeptree-2.23.4.tar.gz"
  sha256 "8a9e7ceee623d1cb2839b6802c26dd40959d31ecaa1468d32616f7082658f135"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7b7a0798324a8441d12bdfce3cd11af1b12ff1b5e478366449c8be532fb57154"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7b7a0798324a8441d12bdfce3cd11af1b12ff1b5e478366449c8be532fb57154"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7b7a0798324a8441d12bdfce3cd11af1b12ff1b5e478366449c8be532fb57154"
    sha256 cellar: :any_skip_relocation, sonoma:        "65ff974611d2283bef79292484b6c373de54696a87a53be7871840189354aa3f"
    sha256 cellar: :any_skip_relocation, ventura:       "65ff974611d2283bef79292484b6c373de54696a87a53be7871840189354aa3f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7b7a0798324a8441d12bdfce3cd11af1b12ff1b5e478366449c8be532fb57154"
  end

  depends_on "python@3.13"

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/51/65/50db4dda066951078f0a96cf12f4b9ada6e4b811516bf0262c0f4f7064d4/packaging-24.1.tar.gz"
    sha256 "026ed72c8ed3fcce5bf8950572258698927fd1dbda10a5e981cdf0ac37f4f002"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match "pipdeptree==#{version}", shell_output("#{bin}/pipdeptree --all")

    assert_empty shell_output("#{bin}/pipdeptree --user-only").strip

    assert_equal version.to_s, shell_output("#{bin}/pipdeptree --version").strip
  end
end
