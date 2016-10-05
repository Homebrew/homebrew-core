class Fonttools < Formula
  desc "Library for manipulating fonts"
  homepage "https://github.com/fonttools/fonttools"
  url "https://pypi.python.org/packages/d6/c4/688022e14fe8b8e899b40fd8eddece9f3e35b409267220432ac5f01e52c4/fonttools-3.1.2.zip"
  sha256 "1e36cdaf52f93414f4ba9848e043630058b59f1ef4f1900bb1dd948f8e7ec55a"
  head "https://github.com/fonttools/fonttools.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "684979aedb42ed576575e2eea0aa42d3669a3242d9025be1a0c1263fae097226" => :sierra
    sha256 "d2aca5663043850875bd16bb04af383eaee14b4b205c8595fbda20ae0867429e" => :el_capitan
    sha256 "2639039f72920032e0dc6ce6faf15b837487c8561936412c437497c23bd248d0" => :yosemite
    sha256 "eaa0a7decad7e731eae45b93364d18bdadbfadcf39f9a14a6f4e78d55f0b757f" => :mavericks
  end

  option "with-pygtk", "Build with pygtk support for pyftinspect"

  depends_on :python if MacOS.version <= :snow_leopard
  depends_on "pygtk" => :optional

  def install
    ENV.prepend_create_path "PYTHONPATH", libexec/"lib/python2.7/site-packages/FontTools"

    system "python", *Language::Python.setup_install_args(libexec)

    bin.install Dir["#{libexec}/bin/*"]
    bin.env_script_all_files(libexec/"bin", :PYTHONPATH => ENV["PYTHONPATH"])
  end

  test do
    cp "/Library/Fonts/Arial.ttf", testpath
    system bin/"ttx", "Arial.ttf"
  end
end
