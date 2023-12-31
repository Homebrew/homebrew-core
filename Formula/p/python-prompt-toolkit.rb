class PythonPromptToolkit < Formula
  desc "Library for building powerful interactive CLI in Python"
  homepage "https://python-prompt-toolkit.readthedocs.io/en/master/"
  url "https://files.pythonhosted.org/packages/cc/c6/25b6a3d5cd295304de1e32c9edbcf319a52e965b339629d37d42bb7126ca/prompt_toolkit-3.0.43.tar.gz"
  sha256 "3527b7af26106cbc65a040bcc84839a3566ec1b051bb0bfe953631e704b0ff7d"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "934456314076c62f2dbdb9b8b098355f0cb4c47d84e34ef64d006eb1aae2281a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d89908b51aed4996700b0896032edd8d16b01cd5fceb3ebd10fefbb5622f0e0a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d2a8972c4887b45b6c5d343c921f39e35dd6cc9874cf4bd21baf0a0b704ee32b"
    sha256 cellar: :any_skip_relocation, sonoma:         "280ab38f35e9f8bce803b87bac7805cc2f139df4d17bda239225cb925dca4872"
    sha256 cellar: :any_skip_relocation, ventura:        "e03c5db3b09d68dd57ab4e9978da3422c805858300504103cd65394b3a80b431"
    sha256 cellar: :any_skip_relocation, monterey:       "a15059cff1d8104b14a2877521d420a0a8173ba27a9b9816c241e1fb50b2dd45"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6a8a6a9acbabf2d0d6be2b6082b08d4106a57e4b7e9cbfd16e970181168c6a3d"
  end

  depends_on "python-setuptools" => :build
  depends_on "python@3.11" => [:build, :test]
  depends_on "python@3.12" => [:build, :test]
  depends_on "python-wcwidth"

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
      system python_exe, "-c", "from prompt_toolkit import prompt"
    end
  end
end
