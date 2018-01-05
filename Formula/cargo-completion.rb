class CargoCompletion < Formula
  desc "Bash and Zsh completion for Cargo"
  homepage "https://github.com/rust-lang/cargo"
  url "https://github.com/rust-lang/cargo/archive/0.24.0.tar.gz"
  sha256 "a9d4291254a1d622d3c3cb942aaa56ab4059b8d04915c3af234f0362f14722e8"
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
