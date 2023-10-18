class PythonPyparsing < Formula
  desc "Python library for creating PEG parsers"
  homepage "https://github.com/pyparsing/pyparsing"
  url "https://files.pythonhosted.org/packages/37/fe/65c989f70bd630b589adfbbcd6ed238af22319e90f059946c26b4835e44b/pyparsing-3.1.1.tar.gz"
  sha256 "ede28a1a32462f5a9705e07aea48001a08f7cf81a021585011deba701581a0db"
  license "MIT"
  revision 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "dd4702dfb8ca84f6088904991687e1690099a738947f997f05e411654f50140e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b7c4a8ef0422d4a6fc0f4af53c1c3d36b7c3b7df6f6742a6f662eabe78051066"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f1ddfbe02098513fc95abbb1a46106a1dee11475fac36ff58c9145fcf54c4b37"
    sha256 cellar: :any_skip_relocation, sonoma:         "f356e11a1c867f454d95c8a51b3dc491a2e8e5372738f29110bc68e622890f9c"
    sha256 cellar: :any_skip_relocation, ventura:        "fd2fb9835901fd61c84da44f06f316e22a5adec5448e71fbbef1022d7f5d5a59"
    sha256 cellar: :any_skip_relocation, monterey:       "24ffc68ca0508e01980dd8a09cbaa6725959ab7fac4da7465ae990c4b48c4582"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d1abf8870bb9b2765d5817421148000cdc7be9c9a51b54f6e0784f0d479394c5"
  end

  depends_on "python-flit-core" => :build
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
      system python_exe, "-c", "import pyparsing"
    end
  end
end
