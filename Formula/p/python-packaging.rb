class PythonPackaging < Formula
  desc "Core utilities for Python packages"
  homepage "https://packaging.pypa.io/"
  url "https://files.pythonhosted.org/packages/b9/6c/7c6658d258d7971c5eb0d9b69fa9265879ec9a9158031206d47800ae2213/packaging-23.1.tar.gz"
  sha256 "a392980d2b6cffa644431898be54b0045151319d1e7ec34f0cfed48767dd334f"
  license any_of: ["Apache-2.0", "BSD-2-Clause"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "75d74ba58342b0d07689d5c549fc073f90c0b0788bff78a3b1ad18c01e49a6e2"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4a9574de025b17353bdaab4d45b07273fa26ed8f167508782e9c403fd37e4cb8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "52d7fa0db020984528e33f8d5c6d2c223275ffdf093d2d43968ef4350e788bf3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a25acfbee4bf5ecbd192ba56cb05a2ef00e39f82f4b822e0803c1aac8735bcb0"
    sha256 cellar: :any_skip_relocation, sonoma:         "912fbb0b48562acb5a88e0d21ad5dc3f3b666a0f2348c9ae7fb56aa565cb3e38"
    sha256 cellar: :any_skip_relocation, ventura:        "078c34862b7c0616eae6329e8389e1bba56c42441efbbf6e53a7a7d193deb797"
    sha256 cellar: :any_skip_relocation, monterey:       "19c964a773ade9e38e3894a139ccb89a49d717f977e88e796f22b5faeebff6d0"
    sha256 cellar: :any_skip_relocation, big_sur:        "4d7022e584f9f17f7fcf85d638a6dfacba67dea593620a1965744d301b85b620"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e80a9bfba138c421ead861d29127e0af76d68e10b73127f6b54947e145b3ffe6"
  end

  depends_on "python-flit-core" => :build
  depends_on "python@3.10" => [:build, :test]
  depends_on "python@3.11" => [:build, :test]
  depends_on "python@3.9" => [:build, :test]

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
      system python_exe, "-c", "import packaging"
    end
  end
end
