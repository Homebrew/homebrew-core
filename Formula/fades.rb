class Fades < Formula
  desc "Automatically handle virtualenvs for python scripts"
  homepage "https://fades.readthedocs.org/"
  url "https://files.pythonhosted.org/packages/59/18/cc80eb5c0a2e15c4b95df6a3c6158e06acb2e075ef2b811753936a6bdf57/fades-6.0.1.tar.gz"
  sha256 "747ee3a159be1cb7512fd7ea4163d22e2734209e474aa2dbbccc29a0f0c92d09"
  revision 1
  head "https://github.com/PyAr/fades.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "13eceff41cb2181ead4f0993f3726b3f2f5887dede5b7013167360af923dc3dc" => :high_sierra
    sha256 "13eceff41cb2181ead4f0993f3726b3f2f5887dede5b7013167360af923dc3dc" => :sierra
    sha256 "13eceff41cb2181ead4f0993f3726b3f2f5887dede5b7013167360af923dc3dc" => :el_capitan
  end

  depends_on "python3"

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
