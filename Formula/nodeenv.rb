class Nodeenv < Formula
  include Language::Python::Virtualenv

  desc "Node.js virtual environment builder"
  homepage "https://github.com/ekalinin/nodeenv"
  url "https://files.pythonhosted.org/packages/ae/22/1405bb4eb1fcecc41349814119a7e8282a734b60b96589ddd78214ba1614/nodeenv-1.1.1.tar.gz"
  sha256 "b31e0940bf8ef7df0299c45c687662e7fda8e14279d28e9a9113d2d7be9f0c9c"

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
