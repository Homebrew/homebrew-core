class Nodeenv < Formula
  include Language::Python::Virtualenv

  desc "Node.js virtual environment builder"
  homepage "https://github.com/ekalinin/nodeenv"
  url "https://files.pythonhosted.org/packages/a0/d0/a7f6443901894a6c93db42e7fa2f2e2135ca2fcb5f466b8e21cce49d596e/nodeenv-1.1.0.tar.gz"
  sha256 "4a592f8cb891c4894113007be8f5d886a215695ef2e6f84ddf8a0be979c2879a"

  bottle do
    cellar :any_skip_relocation
    sha256 "d3149f4b11bf66ddccc613e1446312db08d9e148020e07b837ccca76a80899e6" => :sierra
    sha256 "1b36e1a6c3a00127d5cfc87149efb68c18a8d4744b28bea67ee791bd251bd594" => :el_capitan
    sha256 "dd14be6825ada729dc47ba64feb05b67dfe5c8071af0bff8bc85db74d82a8b04" => :yosemite
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
