class PythonTroveClassifiers < Formula
  desc "Canonical source for classifiers on PyPI"
  homepage "https://github.com/pypa/trove-classifiers"
  url "https://files.pythonhosted.org/packages/1e/8e/7551fc3e3810a529d410e78507e879aedfad2387e8c06c98e98e0c3a710e/trove-classifiers-2024.2.23.tar.gz"
  sha256 "8385160a12aac69c93fff058fb613472ed773a24a27eb3cd4b144cfbdd79f38c"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2d684221a1a2e94c626738e636149e01748295f08a361c27e52e60544b715648"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "386239ec68a6bc3ab9ff171d9e69b075c6e3cc753904cea24d0348e7462b49f5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d09c3efe21d9a9618c5be26037164176cf3311512281b39bde53ba8c784d750f"
    sha256 cellar: :any_skip_relocation, sonoma:         "74b1e490b9aaa7858636ab619fd0f93c6b298a09c2816cbc8afee42aeebb4e43"
    sha256 cellar: :any_skip_relocation, ventura:        "57836cfa293cb73d9077b43e5618cd1ddf38b674ddea4b301edb64d1d00bfdc9"
    sha256 cellar: :any_skip_relocation, monterey:       "0870dbf3a9d81290793faf11d9eab1a2ef53c228d879c2987ae3cf40051f9a97"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3fc30c1b36b3df8247f2355fef806f935162a23cb80d9cc59e561cb92c2dfaf0"
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

  test do
    pythons.each do |python|
      python_exe = python.opt_libexec/"bin/python"
      classifiers = shell_output("#{python_exe} -m trove_classifiers")
      assert_match "Environment :: MacOS X", classifiers
    end
  end
end
