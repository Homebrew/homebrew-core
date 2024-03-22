class PythonKiwisolver < Formula
  desc "Efficient C++ implementation of the Cassowary constraint solving algorithm"
  homepage "https://github.com/nucleic/kiwi"
  url "https://files.pythonhosted.org/packages/b9/2d/226779e405724344fc678fcc025b812587617ea1a48b9442628b688e85ea/kiwisolver-1.4.5.tar.gz"
  sha256 "e57e563a57fb22a142da34f38acc2fc1a5c864bc29ca1517a88abc963e60d6ec"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c2bdb8889b06d7a5eece6fdc613aa9d73c97932d59a13b5a0c6ecc1a45059ce7"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b4bfd4e620f5031724a9cf816cbd4a08efa6e36ded11cb2880c41e6354c36f7a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e3423e18e16cf3695e0e2341b0f49adf41299751ee4449425cb4f806474bac01"
    sha256 cellar: :any_skip_relocation, sonoma:         "b8f8d784fe353e62777eed318050b88aa67cc33e3ac5de3ed87218699bcd9336"
    sha256 cellar: :any_skip_relocation, ventura:        "263e8cda47a6bc5f514149b087230e810802af2c22165e456ad4c7e546bc0b75"
    sha256 cellar: :any_skip_relocation, monterey:       "62a8f019764ee2d4c4cd664b32df26c7bfd94499a6589d11ed05f7e7857174fb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "915be7dabf6f43d670240e0dd88e85076d90162bb2d349cf5f53be4d2751bed2"
  end

  depends_on "python-build" => :build
  depends_on "python@3.11" => [:build, :test]
  depends_on "python@3.12" => [:build, :test]

  def pythons
    deps.map(&:to_formula).sort_by(&:version).filter { |f| f.name.start_with?("python@") }
  end

  def install
    pythons.each do |python|
      python_exe = python.opt_libexec/"bin/python"
      system python_exe, "-m", "build", "--wheel"
      system python_exe, "-m", "pip", "install", *std_pip_args, Dir["dist/kiwisolver-*.whl"].first
      rm_rf "dist"
    end
  end

  test do
    pythons.each do |python|
      python_exe = python.opt_libexec/"bin/python"
      system python_exe, "-c", "import kiwisolver"
    end
  end
end
