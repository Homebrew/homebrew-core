class Mypy < Formula
  desc "Experimental optional static type checker for Python"
  homepage "http://www.mypy-lang.org/"
  url "https://github.com/python/mypy.git",
      :tag => "v0.620",
      :revision => "67b260f0fec0b0d97c92529359796e9ad5c1a30d"
  head "https://github.com/python/mypy.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "c2f95dbe1311c93bc8e1cc0952f805c8aa89630f4b5c50384cd3315c52d80722" => :high_sierra
    sha256 "6211d82f4fd1de37c1bb941a25c23fb39ef8536507251024b12bab1b7e83ae6f" => :sierra
    sha256 "aac6db9b95a9f5aa1f9e637ba080f180547876dd5c5efd519270920db541cafd" => :el_capitan
  end

  option "without-sphinx-doc", "Don't build documentation"

  deprecated_option "without-docs" => "without-sphinx-doc"

  depends_on "python"
  depends_on "sphinx-doc" => [:build, :recommended]

  resource "psutil" do
    url "https://files.pythonhosted.org/packages/51/9e/0f8f5423ce28c9109807024f7bdde776ed0b1161de20b408875de7e030c3/psutil-5.4.6.tar.gz"
    sha256 "686e5a35fe4c0acc25f3466c32e716f2d498aaae7b7edc03e2305b682226bcf6"
  end

  resource "sphinx_rtd_theme" do
    url "https://files.pythonhosted.org/packages/1c/f2/a1361e5f399e0b4182d031065eececa63ddb8c19a0616b03f119c4d5b6b4/sphinx_rtd_theme-0.4.0.tar.gz"
    sha256 "de88d637a60371d4f923e06b79c4ba260490c57d2ab5a8316942ab5d9a6ce1bf"
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
