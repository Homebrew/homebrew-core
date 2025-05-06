class PythonArgcomplete < Formula
  include Language::Python::Virtualenv

  desc "Tab completion for Python argparse"
  homepage "https://kislyuk.github.io/argcomplete/"
  url "https://files.pythonhosted.org/packages/16/0f/861e168fc813c56a78b35f3c30d91c6757d1fd185af1110f1aec784b35d0/argcomplete-3.6.2.tar.gz"
  sha256 "d0519b1bc867f5f4f4713c41ad0aba73a4a5f007449716b16f385f2166dc6adf"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ab68f1949e1049b9d0d2b844312090763d9b589c5e0cf7727486f987a6a28088"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ab68f1949e1049b9d0d2b844312090763d9b589c5e0cf7727486f987a6a28088"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ab68f1949e1049b9d0d2b844312090763d9b589c5e0cf7727486f987a6a28088"
    sha256 cellar: :any_skip_relocation, sonoma:        "bf80f1c3d1bbc90a5fb4fae7c8452c430db2ddba42d274d2fc8c5e3646c95b29"
    sha256 cellar: :any_skip_relocation, ventura:       "bf80f1c3d1bbc90a5fb4fae7c8452c430db2ddba42d274d2fc8c5e3646c95b29"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0afc8245b8dd5253ca6303cae254b3f9ecc25755b13a7d23f71d2040223f3dc5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0afc8245b8dd5253ca6303cae254b3f9ecc25755b13a7d23f71d2040223f3dc5"
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
