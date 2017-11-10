class Mypy < Formula
  desc "Experimental optional static type checker for Python"
  homepage "http://www.mypy-lang.org/"
  url "https://github.com/python/mypy.git",
      :tag => "v0.550",
      :revision => "a8dfedce06cbfbb37220bfcacc8ff4f1e266abe0"
  head "https://github.com/python/mypy.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "b02554fdc4a01a9a3e247cb545514abd8aaa8be35a8a46254c2add53714443e8" => :high_sierra
    sha256 "30064995f021a0861e7c66fbe5713791c7633339effe29f91a16bf72edc09d45" => :sierra
    sha256 "5e3104ebe742dea0e6b5638e919314bfaa2bc290a4ae8126ab4b38fe8f064341" => :el_capitan
  end

  option "without-sphinx-doc", "Don't build documentation"

  deprecated_option "without-docs" => "without-sphinx-doc"

  depends_on :python3
  depends_on "sphinx-doc" => [:build, :recommended]

  resource "psutil" do
    url "https://files.pythonhosted.org/packages/fe/17/0f0bf5792b2dfe6003efc5175c76225f7d3426f88e2bf8d360cfab870cd8/psutil-5.4.1.tar.gz"
    sha256 "42e2de159e3c987435cb3b47d6f37035db190a1499f3af714ba7af5c379b6ba2"
  end

  resource "sphinx_rtd_theme" do
    url "https://files.pythonhosted.org/packages/8b/e5/b1933472424b30affb0a8cea8f0ef052a31ada96e5d1823911d7f4bfdf8e/sphinx_rtd_theme-0.2.4.tar.gz"
    sha256 "2df74b8ff6fae6965c527e97cca6c6c944886aae474b490e17f92adfbe843417"
  end

  resource "typed-ast" do
    url "https://files.pythonhosted.org/packages/52/cf/2ebc7d282f026e21eed4987e42e10964a077c13cfc168b42f3573a7f178c/typed-ast-1.1.0.tar.gz"
    sha256 "57fe287f0cdd9ceaf69e7b71a2e94a24b5d268b35df251a88fef5cc241bf73aa"
  end

  def install
    xy = Language::Python.major_minor_version "python3"

    if build.with? "sphinx-doc"
      # https://github.com/python/mypy/issues/2593
      version_static = buildpath/"mypy/version_static.py"
      version_static.write "__version__ = '#{version}'\n"
      inreplace "docs/source/conf.py", "mypy.version", "mypy.version_static"

      (buildpath/"docs/sphinx_rtd_theme").install resource("sphinx_rtd_theme")
      # Inject sphinx_rtd_theme's path into sys.path
      inreplace "docs/source/conf.py",
                "sys.path.insert(0, os.path.abspath('../..'))",
                "sys.path[:0] = [os.path.abspath('../..'), os.path.abspath('../sphinx_rtd_theme')]"
      system "make", "-C", "docs", "html"
      doc.install Dir["docs/build/html/*"]

      rm version_static
    end

    ENV.prepend_create_path "PYTHONPATH", libexec/"vendor/lib/python#{xy}/site-packages"
    resources.each do |r|
      r.stage do
        system "python3", *Language::Python.setup_install_args(libexec/"vendor")
      end
    end

    ENV.prepend_create_path "PYTHONPATH", libexec/"lib/python#{xy}/site-packages"
    system "python3", *Language::Python.setup_install_args(libexec)

    bin.install Dir[libexec/"bin/*"]
    bin.env_script_all_files(libexec/"bin", :PYTHONPATH => ENV["PYTHONPATH"])
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
