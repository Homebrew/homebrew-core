# This is an exception to Homebrew policy on Python libraries. See:
# https://github.com/Homebrew/homebrew-core/issues/167905#issuecomment-2328118401
class PythonPackaging < Formula
  desc "Core utilities for Python packages"
  homepage "https://packaging.pypa.io/"
  url "https://files.pythonhosted.org/packages/d7/f1/e7a6dd94a8d4a5626c03e4e99c87f241ba9e350cd9e6d75123f992427270/packaging-26.2.tar.gz"
  sha256 "ff452ff5a3e828ce110190feff1178bb1f2ea2281fa2075aadb987c2fb221661"
  license any_of: ["Apache-2.0", "BSD-2-Clause"]

  bottle do
    sha256 cellar: :any_skip_relocation, all: "cacd876587b277e977fbea711b2cd3490842e5480767e18ccac14ab20b2161e2"
  end

  depends_on "python@3.13" => [:build, :test]
  depends_on "python@3.14" => [:build, :test]

  def pythons
    deps.map(&:to_formula)
        .select { |f| f.name.start_with?("python@") }
        .map { |f| f.opt_libexec/"bin/python" }
  end

  def install
    pythons.each do |python|
      system python, "-m", "pip", "install", *std_pip_args(build_isolation: true), "."
    end
  end

  test do
    pythons.each do |python|
      system python, "-c", "import packaging"
    end
  end
end
