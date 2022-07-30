class Nodeenv < Formula
  include Language::Python::Shebang

  desc "Node.js virtual environment builder"
  homepage "https://github.com/ekalinin/nodeenv"
  url "https://github.com/ekalinin/nodeenv/archive/1.7.0.tar.gz"
  sha256 "a9e9e36e1be6439e877c53e7f27ce068f75b82cc08201f2c68471687199cfd7b"
  license "BSD-3-Clause"
  revision 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b62820fdf34eb99d433736cc707c41a506f404ff2043418b62a4ab47a46fe99d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b62820fdf34eb99d433736cc707c41a506f404ff2043418b62a4ab47a46fe99d"
    sha256 cellar: :any_skip_relocation, monterey:       "b62820fdf34eb99d433736cc707c41a506f404ff2043418b62a4ab47a46fe99d"
    sha256 cellar: :any_skip_relocation, big_sur:        "b62820fdf34eb99d433736cc707c41a506f404ff2043418b62a4ab47a46fe99d"
    sha256 cellar: :any_skip_relocation, catalina:       "b62820fdf34eb99d433736cc707c41a506f404ff2043418b62a4ab47a46fe99d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "37ae15c8646dc8c5b6e535eba8040dc303527e07fa1761fa8fd7834f5ec1d8a2"
  end

  uses_from_macos "python"

  def install
    if OS.linux? || MacOS.version >= :catalina
      rw_info = python_shebang_rewrite_info("/usr/bin/env python3")
      rewrite_shebang rw_info, "nodeenv.py"
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
