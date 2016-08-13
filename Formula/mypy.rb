class Mypy < Formula
  desc "Experimental optional static type checker for Python"
  homepage "http://www.mypy-lang.org/"
  url "https://github.com/JukkaL/mypy.git",
      :tag => "v0.4.3",
      :revision => "e5f27adf8f143604af241533cdd69df3ddb8d1c9"
  head "https://github.com/JukkaL/mypy.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "251f784f48ce4154e7fd447d97b7b78e65530ee7fc910661b07a25917a86b765" => :el_capitan
    sha256 "317ded0c3972fbd1132c312673b6868d8021749a61448b2e0006ad9098de6ff7" => :yosemite
    sha256 "80405da001e50eb6df68a136929aff46f1131300a369bc432d7b0433a532984c" => :mavericks
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
