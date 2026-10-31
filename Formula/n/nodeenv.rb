class Nodeenv < Formula
  include Language::Python::Shebang

  desc "Node.js virtual environment builder"
  homepage "https://ekalinin.github.io/nodeenv/"
  url "https://github.com/ekalinin/nodeenv/archive/refs/tags/1.12.0.tar.gz"
  sha256 "f3440cca5e907a733727b799d065ec56a9cd4be99ef5608eee0b7689d137893d"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "06a9e9b6cdbf67369769908e9b7ab88110e0e1ac3a743c3437bf9c18a31da11e"
  end

  depends_on "python@3.15"

  def install
    rewrite_shebang detected_python_shebang, "nodeenv.py"
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
