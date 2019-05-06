class CargoCompletion < Formula
  desc "Bash and Zsh completion for Cargo"
  homepage "https://github.com/rust-lang/cargo"
  url "https://github.com/rust-lang/cargo/archive/0.35.0.tar.gz"
  sha256 "59d27a00be827f30a26700240dc0651ded5e0ff035f6efb0319a0a0267fea22d"
  version_scheme 1
  head "https://github.com/rust-lang/cargo.git"

  bottle :unneeded

  # Upstream patch that fixes the compatibility with the macOS stock bash.
  # See rust-lang/cargo#6905.
  patch do
    url "https://github.com/rust-lang/cargo/commit/e2c519dd7ac61e4d2f94cad60ef920ce4aa1718f.patch?full_index=1"
    sha256 "3dd6a7914ac133b51c4004ac1d43ffb9fc6b87d2635e761ff488170bf06584ec"
  end

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
