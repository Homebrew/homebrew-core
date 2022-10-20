class Py3cairo < Formula
  desc "Python 3 bindings for the Cairo graphics library"
  homepage "https://cairographics.org/pycairo/"
  url "https://github.com/pygobject/pycairo/releases/download/v1.21.0/pycairo-1.21.0.tar.gz"
  sha256 "251907f18a552df938aa3386657ff4b5a4937dde70e11aa042bc297957f4b74b"
  license any_of: ["LGPL-2.1-only", "MPL-1.1"]
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "ff63b1420cb6450a4ad5d7099cfe3de573af17bff5a6eac905d1052ff8b1577f"
    sha256 cellar: :any,                 arm64_big_sur:  "2483f93ce39583d9fde00e42c0081c86572ec15de319ff15d4ea705aefc7fda0"
    sha256 cellar: :any,                 monterey:       "03e594802bce3f9c7e3cbcc55d0007330b0205d61c74e084a54e919eb9b69653"
    sha256 cellar: :any,                 big_sur:        "de0509d506c8c4ecf70763da2ccb3215340e3cf448b7bb72d44fa4615e58c649"
    sha256 cellar: :any,                 catalina:       "b280fe6a04a07bd23aa6f8e2c159cd33ee56927ef0fa26ed34a2cb61738c3efe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c90aac79478bed8998388c08f53d765fbafb6d74babef7c71a79fbf77a73bc29"
  end

  depends_on "pkg-config" => :build
  depends_on "python@3.10" => [:build, :test]
  depends_on "python@3.9" => [:build, :test]
  depends_on "cairo"

  def pythons
    deps.map(&:to_formula)
        .select { |f| f.name.match?(/^python@\d\.\d+$/) }
        .map { |f| f.opt_libexec/"bin/python" }
  end

  def install
    pythons.each do |python|
      system python, *Language::Python.setup_install_args(prefix, python), "--install-data=#{prefix}"
    end
  end

  test do
    pythons.each do |python|
      system python, "-c", "import cairo; print(cairo.version)"
    end
  end
end
