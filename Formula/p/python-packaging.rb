class PythonPackaging < Formula
  desc "Core utilities for Python packages"
  homepage "https://packaging.pypa.io/"
  url "https://files.pythonhosted.org/packages/fb/2b/9b9c33ffed44ee921d0967086d653047286054117d584f1b1a7c22ceaf7b/packaging-23.2.tar.gz"
  sha256 "048fb0e9405036518eaaf48a55953c750c11e1a1b68e0dd1a9d62ed0c092cfc5"
  license any_of: ["Apache-2.0", "BSD-2-Clause"]

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ee5a31442eccd4a7ce3b9a365fd88264e914fe7afc91b3de28ace70eced8b86f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "76ace9a9b04aa1e07d3b9cf07acbe088881065172e25f44799c4c0036258ca75"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ae9315d8585468178030e9b32351744f2cd057086c9bd67cc12cfc486ed3479f"
    sha256 cellar: :any_skip_relocation, sonoma:         "4eaa26e439f8d562fa18136160a266ac757ff2af568603b90bfe48724a9cdbc5"
    sha256 cellar: :any_skip_relocation, ventura:        "ce193b85667d7f05a6fdfca9b2968fcb85775a0e314c45dc651229a1b5a16113"
    sha256 cellar: :any_skip_relocation, monterey:       "7dd356b572313b213ddfd09061f1f44406b23a5b829009050578ec68a53ffbe1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "de73dc0fe241ca6633a0f99910ded62c204666ba03601c5b00bd5437e2b4265c"
  end

  depends_on "python-flit-core" => :build
  depends_on "python@3.10" => [:build, :test]
  depends_on "python@3.11" => [:build, :test]
  depends_on "python@3.12" => [:build, :test]

  def pythons
    deps.map(&:to_formula)
        .select { |f| f.name.start_with?("python@") }
        .map { |f| f.opt_libexec/"bin/python" }
  end

  def install
    pythons.each do |python|
      system python, "-m", "pip", "install", *std_pip_args, "."
    end
  end

  test do
    pythons.each do |python|
      system python, "-c", "import packaging"
    end
  end
end
