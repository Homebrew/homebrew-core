class Nodeenv < Formula
  include Language::Python::Shebang

  desc "Node.js virtual environment builder"
  homepage "https://github.com/ekalinin/nodeenv"
  url "https://github.com/ekalinin/nodeenv/archive/1.7.0.tar.gz"
  sha256 "a9e9e36e1be6439e877c53e7f27ce068f75b82cc08201f2c68471687199cfd7b"
  license "BSD-3-Clause"
  revision 1

  bottle do
    sha256 cellar: :any_skip_relocation, all: "dfbd40ce1e67ad9d87f4f4fbcee25019bf49957456d5fa6b41e2e9493a6c43a0"
  end

  uses_from_macos "python"

  def install
    if OS.linux? || MacOS.version >= :catalina
      rewrite_shebang detected_python_shebang(use_python_from_path: true), "nodeenv.py"
    end
    bin.install "nodeenv.py" => "nodeenv"
  end

  test do
    system bin/"nodeenv", "--node=16.0.0", "--prebuilt", "env-16.0.0-prebuilt"
    # Dropping into the virtualenv itself requires sourcing activate which
    # isn't easy to deal with. This ensures current Node installed & functional.
    ENV.prepend_path "PATH", testpath/"env-16.0.0-prebuilt/bin"

    (testpath/"test.js").write "console.log('hello');"
    assert_match "hello", shell_output("node test.js")
    assert_match "v16.0.0", shell_output("node -v")
  end
end
