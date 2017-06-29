class Nodeenv < Formula
  include Language::Python::Virtualenv

  desc "Node.js virtual environment builder"
  homepage "https://github.com/ekalinin/nodeenv"
  url "https://files.pythonhosted.org/packages/d5/33/0ec380a95c527b1c6077bcedfc7c4d05b275f56b15a0e7f9a3da9558cd02/nodeenv-1.1.3.tar.gz"
  sha256 "0d7bdb2f5583839cabdbab2ebc091f28cb1d947cc077431b77002e8396b089f9"

  bottle do
    cellar :any_skip_relocation
    sha256 "d36e410297cf9fcd4970ee07a91343390b0f5e1b38bf830987cc5710f6c42b8b" => :sierra
    sha256 "7c97359ed2b57939aac392229d0e9cef0fe0942c5f7c23fd203c9ebb7111fd5c" => :el_capitan
    sha256 "b776c11f551766eb8756da7bf9dd27caf60eaa805cf7d0ed07c7e8ce0d915565" => :yosemite
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    system bin/"nodeenv", "--node=0.10.40", "--prebuilt", "env-0.10.40-prebuilt"
    # Dropping into the virtualenv itself requires sourcing activate which
    # isn't easy to deal with. This ensures current Node installed & functional.
    ENV.prepend_path "PATH", testpath/"env-0.10.40-prebuilt/bin"

    (testpath/"test.js").write "console.log('hello');"
    assert_match "hello", shell_output("node test.js")
    assert_match "v0.10.40", shell_output("node -v")
  end
end
