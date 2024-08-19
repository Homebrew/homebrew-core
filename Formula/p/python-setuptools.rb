class PythonSetuptools < Formula
  desc "Easily download, build, install, upgrade, and uninstall Python packages"
  homepage "https://setuptools.pypa.io/"
  url "https://files.pythonhosted.org/packages/ce/ef/013ded5b0d259f3fa636bf35de186f0061c09fbe124020ce6b8db68c83af/setuptools-72.2.0.tar.gz"
  sha256 "80aacbf633704e9c8bfa1d99fa5dd4dc59573efcf9e4042c13d3bcef91ac2ef9"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2aca98bb0ed8587abe2c80f21be9cfd26b8080f473255d8d4c2ffb2dbeaf2d83"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2aca98bb0ed8587abe2c80f21be9cfd26b8080f473255d8d4c2ffb2dbeaf2d83"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2aca98bb0ed8587abe2c80f21be9cfd26b8080f473255d8d4c2ffb2dbeaf2d83"
    sha256 cellar: :any_skip_relocation, sonoma:         "af018f67b90d66bbdf282a49c90bfec38d79698aff6650d4849ca8a2c479c0f5"
    sha256 cellar: :any_skip_relocation, ventura:        "af018f67b90d66bbdf282a49c90bfec38d79698aff6650d4849ca8a2c479c0f5"
    sha256 cellar: :any_skip_relocation, monterey:       "af018f67b90d66bbdf282a49c90bfec38d79698aff6650d4849ca8a2c479c0f5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7f830d1c33d280facbcf444826208833e47cdcdc9428842d557da8288141df57"
  end

  depends_on "python@3.12" => [:build, :test]

  def pythons
    deps.map(&:to_formula)
        .select { |f| f.name.match?(/^python@\d\.\d+$/) }
        .map { |f| f.opt_libexec/"bin/python" }
  end

  def install
    pythons.each do |python|
      system python, "-m", "pip", "install", *std_pip_args, "."
    end
  end

  test do
    pythons.each do |python|
      system python, "-c", "import setuptools"
    end
  end
end
