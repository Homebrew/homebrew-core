class Mypy < Formula
  desc "Experimental optional static type checker for Python"
  homepage "http://www.mypy-lang.org/"
  url "https://github.com/python/mypy.git",
      :tag => "v0.560",
      :revision => "51e044c4ecf2a52fc6c41ee63019723e0d3061e1"
  revision 2
  head "https://github.com/python/mypy.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "b8dd7f57ce6f17523235fd16755a949e2e0167653536fc4f7c6adf87377f8097" => :high_sierra
    sha256 "81f7cfaef265bcab1013c5f84485ebcb452297414cb7bfaf74534cc0da82c7f8" => :sierra
    sha256 "3d5fc369e02357ed5f8dbba18b411014cbef7106b09c8ae69e5a890695bc1437" => :el_capitan
  end

  option "without-sphinx-doc", "Don't build documentation"

  deprecated_option "without-docs" => "without-sphinx-doc"

  depends_on "python"
  depends_on "sphinx-doc" => [:build, :recommended]

  resource "psutil" do
    url "https://files.pythonhosted.org/packages/54/24/aa854703715fa161110daa001afce75d21d1840e9ab5eb28708d6a5058b0/psutil-5.4.2.tar.gz"
    sha256 "00a1f9ff8d1e035fba7bfdd6977fa8ea7937afdb4477339e5df3dba78194fe11"
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
