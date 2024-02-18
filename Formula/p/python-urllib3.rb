class PythonUrllib3 < Formula
  desc "HTTP library with thread-safe connection pooling, file post, and more"
  homepage "https://urllib3.readthedocs.io/en/stable/"
  url "https://files.pythonhosted.org/packages/e2/cc/abf6746cc90bc52df4ba730f301b89b3b844d6dc133cb89a01cfe2511eb9/urllib3-2.2.0.tar.gz"
  sha256 "051d961ad0c62a94e50ecf1af379c3aba230c66c710493493560c0c223c49f20"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ec3987e163c6de021d76c33de2f06ade719582b3f5a1313dbe871419756cc79e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d01996e8c654b4a4f07bcb36c2d8066476168c9830028ea9bea827322bd6f74d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bb3a7eac74f167167b909b3d7032346cd79ae491d05611231eef95fdc0f7d190"
    sha256 cellar: :any_skip_relocation, sonoma:         "ef23d75d40e6095100ccda5cd9a27c4eb5c16503f61c53eb7ca10bcb2c24ffec"
    sha256 cellar: :any_skip_relocation, ventura:        "3b98de47e9cab903b705323c3b23f3dffc8eb3f9d2237d7cc5d53ecd3297005e"
    sha256 cellar: :any_skip_relocation, monterey:       "ba10e7fdeacd3be53f1d53887d96d379ff10439b09f763c5eacaabf2570ffde0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1fd5341fb5357da6ca280c9222dd0a2d61faaf8c7fba15efec4cdfa26bbe28c8"
  end

  depends_on "python-hatchling" => :build
  depends_on "python@3.11" => [:build, :test]
  depends_on "python@3.12" => [:build, :test]

  def pythons
    deps.map(&:to_formula).sort_by(&:version).filter { |f| f.name.start_with?("python@") }
  end

  def install
    pythons.each do |python|
      python_exe = python.opt_libexec/"bin/python"
      system python_exe, "-m", "pip", "install", *std_pip_args, "."
    end
  end

  test do
    pythons.each do |python|
      python_exe = python.opt_libexec/"bin/python"
      system python_exe, "-c", "import urllib3"
    end
  end
end
