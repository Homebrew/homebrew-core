class PythonArgcomplete < Formula
  include Language::Python::Virtualenv

  desc "Tab completion for Python argparse"
  homepage "https://kislyuk.github.io/argcomplete/"
  url "https://files.pythonhosted.org/packages/5f/39/27605e133e7f4bb0c8e48c9a6b87101515e3446003e0442761f6a02ac35e/argcomplete-3.5.1.tar.gz"
  sha256 "eb1ee355aa2557bd3d0145de7b06b2a45b0ce461e1e7813f5d066039ab4177b4"
  license "Apache-2.0"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "db7b67601e51e5ff28032dde4c6c311e07a611d1bbe4708c6c42a4c7bd912b3a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "db7b67601e51e5ff28032dde4c6c311e07a611d1bbe4708c6c42a4c7bd912b3a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "db7b67601e51e5ff28032dde4c6c311e07a611d1bbe4708c6c42a4c7bd912b3a"
    sha256 cellar: :any_skip_relocation, sonoma:        "518e92572b64ec91e24b1cb9c64aab5985cd477c0fe6746e705fe3e8202c2e53"
    sha256 cellar: :any_skip_relocation, ventura:       "518e92572b64ec91e24b1cb9c64aab5985cd477c0fe6746e705fe3e8202c2e53"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b7c1a0b591b50cf76d1d38f6b86cc8bf071d1ea3e6b0bdab3c0a076284915e75"
  end

  depends_on "python@3.13"

  def install
    virtualenv_install_with_resources

    # Bash completions are not compatible with Bash 3 so don't use v1 directory.
    # Ref: https://kislyuk.github.io/argcomplete/#global-completion
    bash_completion_script = "argcomplete/bash_completion.d/_python-argcomplete"
    (share/"bash-completion/completions").install bash_completion_script => "python-argcomplete"
    zsh_completion.install_symlink bash_completion/"python-argcomplete" => "_python-argcomplete"
  end

  test do
    output = shell_output("#{bin}/register-python-argcomplete foo")
    assert_match "_python_argcomplete foo", output
  end
end
