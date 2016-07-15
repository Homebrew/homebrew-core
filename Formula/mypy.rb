class Mypy < Formula
  desc "Experimental optional static type checker for Python"
  homepage "http://www.mypy-lang.org/"
  url "https://github.com/JukkaL/mypy.git",
      :tag => "v0.4.3",
      :revision => "e5f27adf8f143604af241533cdd69df3ddb8d1c9"
  head "https://github.com/JukkaL/mypy.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "4d472855d881f585b9236d93d67a09795543950eccb954979c4c98be8008a4a6" => :el_capitan
    sha256 "0ff20999cbd6c391dcce22c949c16701a4dd58aca17cc57e212d6a35e819f751" => :yosemite
    sha256 "bed90ec74eb884802e768059c10d435a5d7f7be2b6b990a1df6bc92291aed4d3" => :mavericks
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
