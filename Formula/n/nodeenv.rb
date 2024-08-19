class Nodeenv < Formula
  include Language::Python::Shebang

  desc "Node.js virtual environment builder"
  homepage "https://github.com/ekalinin/nodeenv"
  url "https://github.com/ekalinin/nodeenv/archive/refs/tags/1.9.1.tar.gz"
  sha256 "0d8ba86a1e4ab68bb16e8f1a1ac4f6261288012c72d4fa4a697949535c2c8d04"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9d7e012463ab68ddcdeb13be8e80d8db2767d7294dcea241c613ee1a3b63e91d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9d7e012463ab68ddcdeb13be8e80d8db2767d7294dcea241c613ee1a3b63e91d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9d7e012463ab68ddcdeb13be8e80d8db2767d7294dcea241c613ee1a3b63e91d"
    sha256 cellar: :any_skip_relocation, sonoma:         "9d7e012463ab68ddcdeb13be8e80d8db2767d7294dcea241c613ee1a3b63e91d"
    sha256 cellar: :any_skip_relocation, ventura:        "9d7e012463ab68ddcdeb13be8e80d8db2767d7294dcea241c613ee1a3b63e91d"
    sha256 cellar: :any_skip_relocation, monterey:       "9d7e012463ab68ddcdeb13be8e80d8db2767d7294dcea241c613ee1a3b63e91d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9fcdb3e228efb7be8356c9c1c3a2fd32bb3e2332be7fe38288f6911e9025fdad"
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
