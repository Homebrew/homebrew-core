class Nodeenv < Formula
  include Language::Python::Virtualenv

  desc "Node.js virtual environment builder"
  homepage "https://github.com/ekalinin/nodeenv"
  url "https://files.pythonhosted.org/packages/79/c1/c772f1e2beb5c67a1ce750a07e9ab790d44b9ff89cd9ff4356197ab68a8c/nodeenv-1.1.2.tar.gz"
  sha256 "6e5e54b2520aff970a8a161750dedecc196b396b9436247859128e53ff7aa074"

  bottle do
    cellar :any_skip_relocation
    sha256 "0ed837ae42c08c4f946452cd04c4b578a5a959d18c8a3419e0f7a483f601681d" => :sierra
    sha256 "df8eecf543f2ad069d88cc710b94d06d14ce62a7c1663979e64119e7b15ffddc" => :el_capitan
    sha256 "5a51c8c3bc7e24034666b743bc35a7bbe97387986480bc0a06fc2cb8db2e1f09" => :yosemite
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
