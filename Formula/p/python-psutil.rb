class PythonPsutil < Formula
  desc "Cross-platform lib for process and system monitoring in Python"
  homepage "https://github.com/giampaolo/psutil"
  url "https://files.pythonhosted.org/packages/2d/01/beb7331fc6c8d1c49dd051e3611379bfe379e915c808e1301506027fce9d/psutil-5.9.6.tar.gz"
  sha256 "e4b92ddcd7dd4cdd3f900180ea1e104932c7bce234fb88976e2a3b296441225a"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "114d14ffb0b20e313a6e536bf49fdf1a2b221174e410119a6e42a987bf688abf"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d99f051f6e255e307f7a6edd0ade3f886302ad66c0c23d3591bed33f9e57fde5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c14dda0268b873f53e06d993c8501c550ba8773f1254deba4a76430320ebee3b"
    sha256 cellar: :any_skip_relocation, sonoma:         "302989eabf141199ac81b115cf5d78cb8c43aa6e8e54a0701536c1a4601217c9"
    sha256 cellar: :any_skip_relocation, ventura:        "e8ce5f3331fa824d492b51d0df1d243a169af54bd4cbd74b90c0cc0c884e3790"
    sha256 cellar: :any_skip_relocation, monterey:       "24e1f3ca80013ecb60721174d0229c179d1cad4f3937e60c22306800d0885327"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3cb95f593edd62967537b3a2cfa2d123c8dc613500b8e41774535eb59643bd28"
  end

  depends_on "python-setuptools" => :build
  depends_on "python@3.11" => [:build, :test]
  depends_on "python@3.12" => [:build, :test]

  def pythons
    deps.map(&:to_formula)
        .select { |f| f.name.start_with?("python@") }
        .map { |f| f.opt_libexec/"bin/python" }
  end

  def install
    pythons.each do |python|
      system python, "-m", "pip", "install", *std_pip_args, "."
    end
  end

  test do
    pythons.each do |python|
      system python, "-c", "import psutil"
    end
  end
end
