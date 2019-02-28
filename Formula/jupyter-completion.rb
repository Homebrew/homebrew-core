class JupyterCompletion < Formula
  desc "Bash and Zsh completion for Jupyter"
  homepage "https://jupyter.org/"
  url "https://files.pythonhosted.org/packages/b6/2d/2804f4de3a95583f65e5dcb4d7c8c7183124882323758996e867f47e72af/jupyter_core-4.4.0.tar.gz"
  sha256 "ba70754aa680300306c699790128f6fbd8c306ee5927976cbe48adacf240c0b7"

  bottle :unneeded

  def install
    bash_completion.install "examples/jupyter-completion.bash" => "jupyter"
    zsh_completion.install "examples/completions-zsh" => "_jupyter"
  end

  test do
    assert_match "-F _jupyter",
      shell_output("source #{bash_completion}/jupyter && complete -p jupyter")
  end
end
