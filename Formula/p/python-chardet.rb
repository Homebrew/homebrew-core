class PythonChardet < Formula
  desc "Python character encoding detector"
  homepage "https://chardet.readthedocs.io/en/latest/"
  url "https://files.pythonhosted.org/packages/f3/0d/f7b6ab21ec75897ed80c17d79b15951a719226b9fababf1e40ea74d69079/chardet-5.2.0.tar.gz"
  sha256 "1b3b6ff479a8c414bc3fa2c0852995695c4a026dcd6d0633b2dd092ca39c1cf7"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3cd2f90530ac02025ce9c507677cc876d0f43a49f67960a1274acfe286bb74c2"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "34e44d47f861cc01c3d3944280648b9df25b41a6a4e95a1836628bb9868ace00"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c68b9dc4bf49a532f729177f7940e27697fc29aa519e09edd236c2021c62e673"
    sha256 cellar: :any_skip_relocation, sonoma:         "236e842fd379d9c94692a6a77e7d3b7436e2f8878f2cb56e72965095434d5a06"
    sha256 cellar: :any_skip_relocation, ventura:        "69c9384779c2805abbdb2621d9207109333e0efacad284ac2cb7337847b8ddf2"
    sha256 cellar: :any_skip_relocation, monterey:       "6d4e54af4f2fa7cfe65af5166d05005a7cf41d99d24d5194097188a385be1a7e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cd4c2fbd024346e2eba9dda0b44a0ba0974b35e3a6c215d1e7c442388fe2c396"
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
      To run `chardetect`, you may need to `brew install #{pythons.last}`
    EOS
  end

  test do
    pythons.each do |python|
      python_exe = python.opt_libexec/"bin/python"
      system python_exe, "-c", "import chardet"
    end

    (testpath/"test.txt").write "你好"
    output = shell_output("#{bin}/chardetect #{testpath}/test.txt")
    assert_match "test.txt: utf-8 with confidence 0.7525", output
  end
end
