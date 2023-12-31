class PythonLxml < Formula
  desc "Pythonic binding for the libxml2 and libxslt libraries"
  homepage "https://github.com/lxml/lxml"
  url "https://files.pythonhosted.org/packages/80/2c/076fafd979728858829fb9ce2e13fa6367b6be9acc4da0cff6367aa6a1ce/lxml-5.0.0.zip"
  sha256 "2219cbf790e701acf9a21a31ead75f983e73daf0eceb9da6990212e4d20ebefe"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6ad5dfbb40691a6ae705bec669c148507b0bba5fb4fb583a5824047f48df8e7c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "280712f9ff8d85341be908b3f3a7e405e053204ece4a4f307de9cea0f9e32388"
    sha256 cellar: :any,                 arm64_monterey: "092975ad981456279c811f37c2b2782f8c3bed3ca8cfad2528c893d268bc0170"
    sha256 cellar: :any_skip_relocation, sonoma:         "684e6144385e87023d0179c4a6ea14df8957ecebf7042d0b69bdbfbb026f53d8"
    sha256 cellar: :any_skip_relocation, ventura:        "42dea02193025b34fd0eee00ddfb086cd16b5356b27493d5aa3ec6c53b781c11"
    sha256 cellar: :any,                 monterey:       "8d5a65fc5f129172f1903e647a931fe78ab1f1e08e782abf83842761f2f0bf50"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "68a53c9015e3a836beafb6324ab63cdff7faaa6a93f9ad62d4b15676d63a80d1"
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
