class Mypy < Formula
  desc "Experimental optional static type checker for Python"
  homepage "http://www.mypy-lang.org/"
  url "https://github.com/python/mypy.git",
      tag:      "v0.800",
      revision: "4c3ea8285a685fbc3934a8a1e3b37beea10f587e"
  license "MIT"
  head "https://github.com/python/mypy.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "c8ce5ece63124e9426eee5fdb666af203fb687ed85e42802da5256b9410f3f28" => :big_sur
    sha256 "bb60227c0abf74657de3f527793816c2dda2e466c9882711d32108574cf85339" => :arm64_big_sur
    sha256 "b6ffae696bf452d07de1f017810fa9beeac4ca49a33528a6dbedef2f7c73f27c" => :catalina
    sha256 "949b53af966482d5e6949e75553531b3deff7eace6ce4c07193c7673acf6d167" => :mojave
  end

  depends_on "sphinx-doc" => :build
  depends_on "python@3.9"

  resource "mypy-extensions" do
    url "https://files.pythonhosted.org/packages/63/60/0582ce2eaced55f65a4406fc97beba256de4b7a95a0034c6576458c6519f/mypy_extensions-0.4.3.tar.gz"
    sha256 "2d82818f5bb3e369420cb3c4060a7970edba416647068eb4c5343488a6c604a8"
  end

  resource "psutil" do
    url "https://files.pythonhosted.org/packages/e1/b0/7276de53321c12981717490516b7e612364f2cb372ee8901bd4a66a000d7/psutil-5.8.0.tar.gz"
    sha256 "0c9ccb99ab76025f2f0bbecf341d4656e9c1351db8cc8a03ccd62e318ab4b5c6"
  end

  resource "sphinx-rtd-theme" do
    url "https://files.pythonhosted.org/packages/4e/e5/0d55470572e0a0934c600c4cda0c98209883aaeb45ff6bfbadcda7006255/sphinx_rtd_theme-0.5.1.tar.gz"
    sha256 "eda689eda0c7301a80cf122dad28b1861e5605cbf455558f3775e1e8200e83a5"
  end

  resource "typed-ast" do
    url "https://files.pythonhosted.org/packages/36/8c/efd8ffe7d242cd389632a11cbc6ce596de49b46ece22760a67b742534368/typed_ast-1.4.2.tar.gz"
    sha256 "9fc0b3cb5d1720e7141d103cf4819aea239f7d136acf9ee4a69b047b7986175a"
  end

  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/16/06/0f7367eafb692f73158e5c5cbca1aec798cdf78be5167f6415dd4205fa32/typing_extensions-3.7.4.3.tar.gz"
    sha256 "99d4073b617d30288f569d3f13d2bd7548c3a7e4c8de87db09a9d29bb3a4a60c"
  end

  def install
    python3 = Formula["python@3.9"].opt_bin/"python3"
    xy = Language::Python.major_minor_version python3

    # https://github.com/python/mypy/issues/2593
    version_static = buildpath/"mypy/version_static.py"
    version_static.write "__version__ = '#{version}'\n"
    inreplace "docs/source/conf.py", "mypy.version", "mypy.version_static"

    (buildpath/"docs/sphinx-rtd-theme").install resource("sphinx-rtd-theme")
    # Inject sphinx_rtd_theme's path into sys.path
    inreplace "docs/source/conf.py",
              "sys.path.insert(0, os.path.abspath('../..'))",
              "sys.path[:0] = [os.path.abspath('../..'), os.path.abspath('../sphinx-rtd-theme')]"
    system "make", "-C", "docs", "html"
    doc.install Dir["docs/build/html/*"]

    rm version_static

    ENV.prepend_create_path "PYTHONPATH", libexec/"vendor/lib/python#{xy}/site-packages"
    resources.each do |r|
      r.stage do
        system python3, *Language::Python.setup_install_args(libexec/"vendor")
      end
    end

    ENV.prepend_create_path "PYTHONPATH", libexec/"lib/python#{xy}/site-packages"
    ENV["MYPY_USE_MYPYC"] = "1"
    system python3, *Language::Python.setup_install_args(libexec)

    bin.install Dir[libexec/"bin/*"]
    bin.env_script_all_files(libexec/"bin", PYTHONPATH: ENV["PYTHONPATH"])
  end

  test do
    (testpath/"broken.py").write <<~EOS
      def p() -> None:
        print('hello')
      a = p()
    EOS
    output = pipe_output("#{bin}/mypy broken.py 2>&1")
    assert_match '"p" does not return a value', output
  end
end
