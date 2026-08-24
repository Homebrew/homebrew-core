# This is an exception to Homebrew policy on Python libraries. See:
# https://github.com/Homebrew/homebrew-core/issues/167905#issuecomment-2328118401
class PythonPackaging < Formula
  desc "Core utilities for Python packages"
  homepage "https://packaging.pypa.io/"
  url "https://files.pythonhosted.org/packages/7d/fa/3944b40b07da9ce895c0e6303a5ab7d53da063554f534556b134a54d6093/packaging-26.3.tar.gz"
  sha256 "94edc256424af38762eb31306eed28beb9f0efc50a8837492c9d6fd6004aed79"
  license any_of: ["Apache-2.0", "BSD-2-Clause"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f7ce5f0b6af0dd3231f10ad0715140a36c56e360011d2574390324f655c43368"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f7ce5f0b6af0dd3231f10ad0715140a36c56e360011d2574390324f655c43368"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f7ce5f0b6af0dd3231f10ad0715140a36c56e360011d2574390324f655c43368"
    sha256 cellar: :any_skip_relocation, sonoma:        "091d97d0c398a712bf90d0f965d37027ae09e6713ba50054f571fa58ddf50512"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f7ce5f0b6af0dd3231f10ad0715140a36c56e360011d2574390324f655c43368"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f7ce5f0b6af0dd3231f10ad0715140a36c56e360011d2574390324f655c43368"
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
