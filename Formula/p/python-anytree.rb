class PythonAnytree < Formula
  desc "Powerful and Lightweight Python Tree Data Structure with various plugins"
  homepage "https://anytree.readthedocs.io/en/stable/"
  url "https://files.pythonhosted.org/packages/f9/44/2dd9c5d0c3befe899738b930aa056e003b1441bfbf34aab8fce90b2b7dea/anytree-2.12.1.tar.gz"
  sha256 "244def434ccf31b668ed282954e5d315b4e066c4940b94aff4a7962d85947830"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "353d20e8180d437225ccd0d94f35bee8cd2d800bcd65e4b44ea9d9129350c546"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1f6221a6daf5d84abd26b653cd3eee01183760caa1beb673ee740aa30fcf9c22"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7aacebee3c63fbcfe99102c99b4ed2b5685b26f71c988e24fe6e90070f0eeb02"
    sha256 cellar: :any_skip_relocation, sonoma:         "fc0d36b010c65d5825f2156d5e4f5c8d43c962af9d7d180f076cf94ebd91bd87"
    sha256 cellar: :any_skip_relocation, ventura:        "20ec71e2c9143173f717eed39928428c12a60fc3efd682a07df11885f5926083"
    sha256 cellar: :any_skip_relocation, monterey:       "fc4d56643f771a64f69666eac8b56a19c92bdeff3afce3ec3e61cef0e723cd03"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "645ba2f4f017d7319e7a74e97ae7c0706ecca18607eeec52730d439a2fe72ebf"
  end

  depends_on "poetry" => :build
  depends_on "python@3.11" => [:build, :test]
  depends_on "python@3.12" => [:build, :test]
  depends_on "six" # upstream issue to drop six, https://github.com/c0fec0de/anytree/issues/249

  def pythons
    deps.map(&:to_formula).sort_by(&:version).filter { |f| f.name.start_with?("python@") }
  end

  def install
    site_packages = Language::Python.site_packages("python3.12")
    ENV.prepend_path "PYTHONPATH", Formula["poetry"].opt_libexec/site_packages

    pythons.each do |python|
      python_exe = python.opt_libexec/"bin/python"
      system python_exe, "-m", "pip", "install", *std_pip_args, "."
    end
  end

  test do
    pythons.each do |python|
      python_exe = python.opt_libexec/"bin/python"
      system python_exe, "-c", "from anytree.iterators import PreOrderIter"
    end
  end
end
