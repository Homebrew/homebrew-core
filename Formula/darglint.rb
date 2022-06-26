class Darglint < Formula
  include Language::Python::Virtualenv

  desc "Python docstring argument linter"
  homepage "https://github.com/terrencepreilly/darglint"
  url "https://files.pythonhosted.org/packages/d4/2c/86e8549e349388c18ca8a4ff8661bb5347da550f598656d32a98eaaf91cc/darglint-1.8.1.tar.gz"
  sha256 "080d5106df149b199822e7ee7deb9c012b49891538f14a11be681044f0bb20da"
  license "MIT"
  head "https://github.com/terrencepreilly/darglint.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7462727f3dc2fa353d3a7c06d2151acd34d361c7e2756c13f61b6f6834c03870"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "42e91f209c5c3a31378b08128e872de32cf6be51cf54ced378a51ef8a2220e42"
    sha256 cellar: :any_skip_relocation, monterey:       "9a671f2790a10f4f7d5c8ccd55249eba10991aadd39040fa4edaf04586d35f33"
    sha256 cellar: :any_skip_relocation, big_sur:        "f1a2ee8eeca7a285648d9c4e2c3d00031025c3f50614f992878bab0f00b57d61"
    sha256 cellar: :any_skip_relocation, catalina:       "f9d1151558abf70184f0ed3d66c94e8a9f1f89a9cf20bae7db030e71e091263a"
    sha256 cellar: :any_skip_relocation, mojave:         "aa84254d72fcccfece16713b9f7648aeaef79831465d2f14032b942a48a17801"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "25cac2c982564d37e9bc4159ef583f2053b5061f5397d2c1a5661df1293916f3"
  end

  depends_on "poetry" => :build
  depends_on "python@3.10"

  def install
    venv = virtualenv_create(libexec, "python3")
    system Formula["poetry"].opt_bin/"poetry", "build", "--format", "wheel", "--verbose", "--no-interaction"
    venv.pip_install_and_link Dir["dist/darglint-*.whl"].first
  end

  test do
    (testpath/"broken.py").write <<~EOS
      def bad_docstring(x):
        """nothing about x"""
        pass
    EOS
    output = pipe_output("#{bin}/darglint -v 2 broken.py 2>&1")
    assert_match "DAR101: Missing parameter(s) in Docstring: - x", output
  end
end
