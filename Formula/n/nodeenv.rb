class Nodeenv < Formula
  include Language::Python::Shebang

  desc "Node.js virtual environment builder"
  homepage "https://ekalinin.github.io/nodeenv/"
  url "https://github.com/ekalinin/nodeenv/archive/refs/tags/1.9.1.tar.gz"
  sha256 "0d8ba86a1e4ab68bb16e8f1a1ac4f6261288012c72d4fa4a697949535c2c8d04"
  license "BSD-3-Clause"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "d1109702686c7f630b61ee8fc84746139594fdd512b04c1019e30adcaec2a7ac"
  end

  uses_from_macos "python"

  def install
    rewrite_shebang detected_python_shebang(use_python_from_path: true), "nodeenv.py"
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
