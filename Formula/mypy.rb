class Mypy < Formula
  desc "Experimental optional static type checker for Python"
  homepage "http://www.mypy-lang.org/"
  url "https://github.com/python/mypy.git",
      :tag => "v0.470",
      :revision => "b0f1ff9334ca068b6fca3937ac8d4fa7c288fc14"
  version "0.4.7"
  head "https://github.com/python/mypy.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "e5c9f3dc61edd6d21d18624515c2dbcdf3e6350e625bd1f58c4ed08cd1c60de9" => :sierra
    sha256 "253e79f891698176f92b87d514b4a13dd7b7c29f15d3583661c207b85f3c2f02" => :el_capitan
    sha256 "c648a15046e55bd70fe60f5e5e6aef2d5f98420bfe725a1efb6b24d0f5571035" => :yosemite
  end

  option "without-sphinx-doc", "Don't build documentation"

  deprecated_option "without-docs" => "without-sphinx-doc"

  depends_on :python3
  depends_on "sphinx-doc" => [:build, :recommended]

  resource "sphinx_rtd_theme" do
    url "https://files.pythonhosted.org/packages/99/b5/249a803a428b4fd438dd4580a37f79c0d552025fb65619d25f960369d76b/sphinx_rtd_theme-0.1.9.tar.gz"
    sha256 "273846f8aacac32bf9542365a593b495b68d8035c2e382c9ccedcac387c9a0a1"
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

    ENV.prepend_create_path "PYTHONPATH", libexec/"lib/python#{xy}/site-packages"
    system "python3", *Language::Python.setup_install_args(libexec)

    bin.install Dir[libexec/"bin/*"]
    bin.env_script_all_files(libexec/"bin", :PYTHONPATH => ENV["PYTHONPATH"])
  end

  test do
    xy = Language::Python.major_minor_version "python3"
    ENV["PYTHONPATH"] = libexec/"lib/python#{xy}/site-packages"

    (testpath/"broken.py").write <<-EOS.undent
      def p() -> None:
        print ('hello')
      a = p()
    EOS

    output = pipe_output("#{bin}/mypy #{testpath}/broken.py 2>&1")
    assert_match "\"p\" does not return a value", output
    system "python3", "-c", "import typing"
  end
end
