class Nodeenv < Formula
  include Language::Python::Virtualenv

  desc "Node.js virtual environment builder"
  homepage "https://github.com/ekalinin/nodeenv"
  url "https://files.pythonhosted.org/packages/fa/62/f3dc0d7b596f7187585520bca14c050909de88866e8f793338de907538cf/nodeenv-1.0.0.tar.gz"
  sha256 "def2a6d927bef8d17c1776edbd5bbc8b7a5f0eee159af53b9924d559fc8d3202"

  bottle do
    cellar :any_skip_relocation
    sha256 "dd60c53b8476a285f79b85bc363a30b06bffd164d2e4daf2ed3d2078bf5b04cb" => :el_capitan
    sha256 "f21ca5ce7ccf6d681c890161e980194f2cde92b0976a0420b8ad86baafa9f12b" => :yosemite
    sha256 "96f6bb2453b18615c4b5201e15b7c81ffa541888ce73ad660982824424d86759" => :mavericks
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
