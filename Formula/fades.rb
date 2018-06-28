class Fades < Formula
  desc "Automatically handle virtualenvs for python scripts"
  homepage "https://fades.readthedocs.org/"
  url "https://files.pythonhosted.org/packages/27/89/dd5b165986f4064d2a3285461e1a15fb7006793b453a7b2a3b518377b8f2/fades-7.0.tar.gz"
  sha256 "b91f2221f1ae8e9eae35f58dac279d2d3935e66de428e79e1509814392449dda"
  revision 1
  head "https://github.com/PyAr/fades.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "9b5c0dd5896b064ec203c052c7719c3e3a9c4c84920a9565ef4e77d459734109" => :high_sierra
    sha256 "9b5c0dd5896b064ec203c052c7719c3e3a9c4c84920a9565ef4e77d459734109" => :sierra
    sha256 "9b5c0dd5896b064ec203c052c7719c3e3a9c4c84920a9565ef4e77d459734109" => :el_capitan
  end

  depends_on "python"

  def install
    pyver = Language::Python.major_minor_version "python3"
    ENV.prepend_create_path "PYTHONPATH", libexec/"lib/python#{pyver}/site-packages"
    system "python3", *Language::Python.setup_install_args(libexec)

    bin.install Dir[libexec/"bin/*"]
    bin.env_script_all_files(libexec/"bin", :PYTHONPATH => ENV["PYTHONPATH"])
  end

  test do
    (testpath/"test.py").write("print('it works')")
    system "#{bin}/fades", testpath/"test.py"
  end
end
