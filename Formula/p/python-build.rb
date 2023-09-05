class PythonBuild < Formula
  desc "Simple, correct PEP 517 build frontend"
  homepage "https://github.com/pypa/build"
  url "https://files.pythonhosted.org/packages/e8/27/f6b1c6d316ef655a10668984575c21feee9eda292bc1d718707566010ea0/build-1.0.0.tar.gz"
  sha256 "49a60f212df4d9925727c2118e1cbe3abf30b393eff7d0e7287d2170eb36844d"
  license "MIT"
  head "https://github.com/pypa/build.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "11d8fa915bd3692dd18b709af436c0c68019b99de8c86c244c07f696cd209dc6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e7ba9531b49f1e6da1c13aa3e9559f8030fe39baf3ebbed743f797277bff3673"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "23e7c635441bd19786223b751d10b1dbb3323066f386b43c168ed2056be7b861"
    sha256 cellar: :any_skip_relocation, ventura:        "40e47e157a16cf16fc05b15ffa53fad4abefcce6203462c8b047a6f58ec7f924"
    sha256 cellar: :any_skip_relocation, monterey:       "0cc2a9e20599a232231ac8a261079d0c535135cfb6ec90fc013c2c9157ce2865"
    sha256 cellar: :any_skip_relocation, big_sur:        "fc0ad0bdb6f1fb5f3cd0daff1abd2e47c6da31eafee8e8f672173b3b6a3cbdd6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "38eeeec61801e5eab1c28d94646f5f9d084a3fbee480fea293c1b09d9abe238f"
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
