class PythonPyparsing < Formula
  desc "Python library for creating PEG parsers"
  homepage "https://click.palletsprojects.com/"
  url "https://files.pythonhosted.org/packages/37/fe/65c989f70bd630b589adfbbcd6ed238af22319e90f059946c26b4835e44b/pyparsing-3.1.1.tar.gz"
  sha256 "ede28a1a32462f5a9705e07aea48001a08f7cf81a021585011deba701581a0db"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "25b7d932df97bdaabd8e6e78ae6f3216ad436f3b697d301bcc9d78d88e150ffd"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "79ced112ba2a082b40b8cd8223fb17288c8538c4e17e84b893e5af5367de00de"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "69724ec58a9ae398b52f44ce831da38e87d388a08675d94b04ff269c0ffd304a"
    sha256 cellar: :any_skip_relocation, ventura:        "7c968e222494cfe4fa73a3d1e3e377b6bf8c0dc9622b1f4ab90e99ceac162620"
    sha256 cellar: :any_skip_relocation, monterey:       "73124f9168de665a4fc1ab992d82a070fb910fb1e5f8fa42e28f20ca31e1a52f"
    sha256 cellar: :any_skip_relocation, big_sur:        "abcfca8076d7aad90989ba59253aacc5ccb34f69f22c3f0608b31d39bdfcbf89"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a118e55b514216b8ee83ed99da9c2463ec63faffdc3c66dae9907694b0f468cb"
  end

  depends_on "python-flit-core" => :build
  depends_on "python@3.10" => [:build, :test]
  depends_on "python@3.11" => [:build, :test]
  depends_on "python@3.9" => [:build, :test]

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
