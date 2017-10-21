class CargoCompletion < Formula
  desc "Bash and Zsh completion for Cargo"
  homepage "https://github.com/rust-lang/cargo"
  url "https://github.com/rust-lang/cargo/archive/0.22.0.tar.gz"
  sha256 "6740e2f8d035a5a5246a12e84a141d37ad4c2b826355aff497e6f1fcfb637aef"
  version_scheme 1
  head "https://github.com/rust-lang/cargo.git"

  bottle :unneeded

  conflicts_with "rust", :because => "both install shell completion for cargo"

  def install
    bash_completion.install "src/etc/cargo.bashcomp.sh" => "cargo"
    zsh_completion.install "src/etc/_cargo"
  end

  test do
    # we need to define a dummy 'cargo' command to force the script to define
    # the completion function
    assert_match "-F _cargo",
      shell_output("cargo() { true;} && source #{bash_completion}/cargo && complete -p cargo")
  end
end
