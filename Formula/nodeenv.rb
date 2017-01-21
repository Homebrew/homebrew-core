class Nodeenv < Formula
  include Language::Python::Virtualenv

  desc "Node.js virtual environment builder"
  homepage "https://github.com/ekalinin/nodeenv"
  url "https://files.pythonhosted.org/packages/a0/d0/a7f6443901894a6c93db42e7fa2f2e2135ca2fcb5f466b8e21cce49d596e/nodeenv-1.1.0.tar.gz"
  sha256 "4a592f8cb891c4894113007be8f5d886a215695ef2e6f84ddf8a0be979c2879a"

  bottle do
    cellar :any_skip_relocation
    sha256 "764265ae83ad6ca81d5281527f839bdf876b65f97f0a5585be155abbcf988006" => :sierra
    sha256 "44cf589f3f2047c0a7dba6cd5a50527476a0c9c7e7dfaacad566ef4ae8bdf43d" => :el_capitan
    sha256 "aee1642ff5cd25cece25bf799aa0aaa76df411d76fec12ac47fe210761537078" => :yosemite
    sha256 "9858124809d2f47681ad3ca501f94807a75fbb3b073f972c16541abc9088e509" => :mavericks
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
