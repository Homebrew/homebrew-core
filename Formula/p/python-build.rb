class PythonBuild < Formula
  desc "Simple, correct PEP 517 build frontend"
  homepage "https://github.com/pypa/build"
  url "https://files.pythonhosted.org/packages/98/e3/83a89a9d338317f05a68c86a2bbc9af61235bc55a0c6a749d37598fb2af1/build-1.0.3.tar.gz"
  sha256 "538aab1b64f9828977f84bc63ae570b060a8ed1be419e7870b8b4fc5e6ea553b"
  license "MIT"
  head "https://github.com/pypa/build.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6c7d65e134ae1ec9434f29a09b01173c9063030e40d86cd1215f62a0d2367195"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7c4512e1e2f776b4a52bc0ff82eb0a2e007bb21d138f006384b8d09121036e40"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "afb0b6f875502b63973fc2c1e9472325d0ab85fa086c93eeabe3e04e31256e7f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7a8dfa82d61e33c41cd97fa79527da7142b806dcc36bf76cb0033bd0bbeba972"
    sha256 cellar: :any_skip_relocation, sonoma:         "f01538ef8f7aab6aebcacd8f4366a43affe8f2e7810a0ac450f40c787fb2d68b"
    sha256 cellar: :any_skip_relocation, ventura:        "99587306f8f7d1e4dabf607bce0a6d48b177bc33135810d7df106e4577eeedd9"
    sha256 cellar: :any_skip_relocation, monterey:       "d978baa3b892b6425e71841db57f5586fc63dfeed2177653d8dd5d94c636217f"
    sha256 cellar: :any_skip_relocation, big_sur:        "fd968afca06466a3991b2e56e75652e25431bc09025b9ca110d1cb149b4fb357"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9e19231a63ff23949df207588ac1255722be55c7c2b75e268f127f10fcfe0a3d"
  end

  depends_on "python-flit-core" => :build
  depends_on "python-packaging"
  depends_on "python-pyproject-hooks"
  depends_on "python@3.11"

  def python3
    which("python3.11")
  end

  def install
    system python3, "-m", "pip", "install", *std_pip_args, "."
  end

  test do
    system python3, "-c", "import build"

    stable.stage do
      system bin/"pyproject-build"
      assert_predicate Pathname.pwd/"dist/build-#{stable.version}.tar.gz", :exist?
      assert_predicate Pathname.pwd/"dist/build-#{stable.version}-py3-none-any.whl", :exist?
    end
  end
end
