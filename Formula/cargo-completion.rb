class CargoCompletion < Formula
  desc "Bash and Zsh completion for Cargo"
  homepage "https://github.com/rust-lang/cargo"
  url "https://github.com/rust-lang/cargo/archive/0.43.1.tar.gz"
  sha256 "e154a7a17e70eb51b1763786768c5e352a9d65bb43b85fca112f5e755dc7f8c7"
  version_scheme 1
  head "https://github.com/rust-lang/cargo.git"

  bottle :unneeded

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
