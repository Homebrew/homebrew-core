class PythonPytz < Formula
  desc "Python library for cross platform timezone"
  homepage "https://pythonhosted.org/pytz/"
  url "https://files.pythonhosted.org/packages/69/4f/7bf883f12ad496ecc9514cd9e267b29a68b3e9629661a2bbc24f80eff168/pytz-2023.3.post1.tar.gz"
  sha256 "7b4fddbeb94a1eba4b557da24f19fdf9db575192544270a9101d8509f9f43d7b"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "072aef416a9d05464f0517c9db9e148dc1567b6f165a14b78699b477e6b6d7c7"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a4ba5592bad5c01118894d5f37e190ffa47715c67a5e5d9445bf617c995c72e3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a2bd1c5719051a3b90217d383b31b4840d54902b3b29a1c45be2be65c43c9d4a"
    sha256 cellar: :any_skip_relocation, sonoma:         "28686b526c8a9b38b947140cb41b003473745c2ea259dfa85055f013205baa2e"
    sha256 cellar: :any_skip_relocation, ventura:        "dd90dc227394ce78ce271fa5d5d2883883df0f54bdd8be72f876401299c5ab63"
    sha256 cellar: :any_skip_relocation, monterey:       "911c249582b5e681bced53b8ec5c05da1e70d15bc6307f8ea28265274805a3fd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "269ae8db67bcb8f0f1334b826e7fbbb818df5226e7d8b43f7e3722ab33afc48d"
  end

  depends_on "python-setuptools" => :build
  depends_on "python@3.10" => [:build, :test]
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
      system python_exe, "-c", "import pytz; print(pytz.timezone('UTC'))"
    end
  end
end
