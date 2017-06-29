class Nodeenv < Formula
  include Language::Python::Virtualenv

  desc "Node.js virtual environment builder"
  homepage "https://github.com/ekalinin/nodeenv"
  url "https://files.pythonhosted.org/packages/d5/33/0ec380a95c527b1c6077bcedfc7c4d05b275f56b15a0e7f9a3da9558cd02/nodeenv-1.1.3.tar.gz"
  sha256 "0d7bdb2f5583839cabdbab2ebc091f28cb1d947cc077431b77002e8396b089f9"

  bottle do
    cellar :any_skip_relocation
    sha256 "89d883152e213d8a38d933272d717ee0aaf229aa5958ad69285091dab09c2138" => :sierra
    sha256 "c2f11f9d4a5a97ee9867ed6d3bd516c228b81308e5b12eca6ac18dc52231cb82" => :el_capitan
    sha256 "4896da3820fe3fa49916753223379063137dc49cead42a4f652d5be9f7454ecc" => :yosemite
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
