class Mypy < Formula
  desc "Experimental optional static type checker for Python"
  homepage "http://www.mypy-lang.org/"
  url "https://github.com/JukkaL/mypy.git",
      :tag => "v0.4.5",
      :revision => "032acb74769ebfd3f08db1ba46623e8e0fed7b94"
  head "https://github.com/JukkaL/mypy.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "39d02d87b748a1958692769b70fa81d5353e560d3e91070e79c7aa310bf27b86" => :sierra
    sha256 "39d02d87b748a1958692769b70fa81d5353e560d3e91070e79c7aa310bf27b86" => :el_capitan
    sha256 "39d02d87b748a1958692769b70fa81d5353e560d3e91070e79c7aa310bf27b86" => :yosemite
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
      ENV.prepend_create_path "PYTHONPATH", libexec/"vendor/lib/python#{xy}/site-packages"
      resource("sphinx_rtd_theme").stage do
        system "python3", *Language::Python.setup_install_args(libexec/"vendor")
      end
      system "make", "-C", "docs", "html"
      doc.install Dir["docs/build/html/*"]
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
