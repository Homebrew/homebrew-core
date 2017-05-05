class Mypy < Formula
  desc "Experimental optional static type checker for Python"
  homepage "http://www.mypy-lang.org/"
  url "https://github.com/python/mypy.git",
      :tag => "v0.510",
      :revision => "12e9107bd0493fb7cdf2d7c07e29c6ef8ca37942"
  head "https://github.com/python/mypy.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "8e14da6d178f4e51af0f3c9933f124dbf203f063f32fffd7e50e86357bce7f7c" => :sierra
    sha256 "028d1bcbdf6291fe1353b3afdbc0ca71c761f0a29fe8d40aff7221aa63dc9a45" => :el_capitan
    sha256 "fa84697f3f43533c17f0b46fe9d8113fd1f3607a1458795824002b2b2b972e4f" => :yosemite
  end

  option "without-sphinx-doc", "Don't build documentation"

  deprecated_option "without-docs" => "without-sphinx-doc"

  depends_on :python3
  depends_on "sphinx-doc" => [:build, :recommended]

  resource "sphinx_rtd_theme" do
    url "https://files.pythonhosted.org/packages/99/b5/249a803a428b4fd438dd4580a37f79c0d552025fb65619d25f960369d76b/sphinx_rtd_theme-0.1.9.tar.gz"
    sha256 "273846f8aacac32bf9542365a593b495b68d8035c2e382c9ccedcac387c9a0a1"
  end

  resource "typed-ast" do
    url "https://files.pythonhosted.org/packages/1e/5e/ca6cef7a04c6c5df26b827e6cdca71af047fcf4d439b28a0f7bbf3b9a720/typed-ast-1.0.1.zip"
    sha256 "b5f578a05498922300b8150716f9689ec4c3e7071f99f6568eed73e68bfa5983"
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
