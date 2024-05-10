class PythonLxml < Formula
  desc "Pythonic binding for the libxml2 and libxslt libraries"
  homepage "https://github.com/lxml/lxml"
  url "https://files.pythonhosted.org/packages/ea/e2/3834472e7f18801e67a3cd6f3c203a5456d6f7f903cfb9a990e62098a2f3/lxml-5.2.1.tar.gz"
  sha256 "3f7765e69bbce0906a7c74d5fe46d2c7a7596147318dbc08e4a2431f3060e306"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "43bc1e20c72d6007370f6fb6cc94515e47167667183067f5ccba68963591f6ee"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "09062b5c0504d39dd9550de4b5def19dd2a7fe015f42c56fc147865a216fe03b"
    sha256 cellar: :any,                 arm64_monterey: "d033f334f13d440c8c87a7d023d6ab2c75414c6e256dfb7a0cd1626c5e26184b"
    sha256 cellar: :any_skip_relocation, sonoma:         "539fe8b1be96a2d96e2dc9bab2e9f644e6ff7cda7e7645223260082882abf2ba"
    sha256 cellar: :any_skip_relocation, ventura:        "4ca6710d9b8c351a31936403849ed7fa3b817a23867a5db380738c38deb1bfeb"
    sha256 cellar: :any,                 monterey:       "f8f38fb1e876ab8e921eab29a56a29d0b08e308af73d10c832b3a8d058e18e04"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "77ccb7b5e089f8cb38cc43f26d3a6bde8045033cd8d4685153551b900c44eb8c"
  end

  depends_on "python-setuptools" => :build
  depends_on "python@3.11" => [:build, :test]
  depends_on "python@3.12" => [:build, :test]

  uses_from_macos "libxml2", since: :ventura
  uses_from_macos "libxslt"

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
      system python_exe, "-c", "import lxml"
    end
  end
end
