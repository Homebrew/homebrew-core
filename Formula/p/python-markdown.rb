class PythonMarkdown < Formula
  desc "Python implementation of Markdown"
  homepage "https://python-markdown.github.io"
  url "https://files.pythonhosted.org/packages/22/02/4785861427848cc11e452cc62bb541006a1087cf04a1de83aedd5530b948/Markdown-3.6.tar.gz"
  sha256 "ed4f41f6daecbeeb96e576ce414c41d2d876daa9a16cb35fa8ed8c2ddfad0224"
  license "BSD-3-Clause"
  head "https://github.com/Python-Markdown/markdown.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "80c1e6c64d617ced2948756928da191e0d808198751ab0cdf0f0e586bcafb427"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "706534c246dd1da457aca07a3afb7b617aec3df5e1edaf6a7d2e0a6a9d05cd04"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "39305e061fa30d960b6b9fbdae1dba7901d84c6ef67458c901cc7842d7355726"
    sha256 cellar: :any_skip_relocation, sonoma:         "b203dc0a1ef3d52eeeaa57f4e5b761a21313cfcf3eaebc16049966639540fdd3"
    sha256 cellar: :any_skip_relocation, ventura:        "1baa39657789a3bb94aad95f586c146360918f6e7b940793632a8f1eeaebe734"
    sha256 cellar: :any_skip_relocation, monterey:       "c1937c58e1ccce926e07481214c35302e43cd6e0fd927ef816e411fade5c95e8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d0c7b63ec327c001ef0d73e522f43d397919a9f06b189abdc4dac88b68d40967"
  end

  depends_on "python-setuptools" => :build
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

  def caveats
    <<~EOS
      To run `markdown_py`, you may need to `brew install #{pythons.last}`
    EOS
  end

  test do
    (testpath/"test.md").write("# Hello World!")
    assert_equal "<h1>Hello World!</h1>", shell_output(bin/"markdown_py test.md").strip

    pythons.each do |python|
      python_exe = python.opt_libexec/"bin/python"
      system python_exe, "-c", "import markdown;"
    end
  end
end
