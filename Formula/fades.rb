class Fades < Formula
  desc "Automatically handle virtualenvs for python scripts"
  homepage "https://fades.readthedocs.org/"
  url "https://pypi.python.org/packages/source/f/fades/fades-5.tar.gz"
  sha256 "1952f496059ba6bac535f2c07effae44a55de0654ababaa1a15879c4b3fa89c1"
  revision 1
  head "https://github.com/PyAr/fades.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "9b4e3a4f485e75ec2a65686db6207dfd5f085c3ae96970933b6ecd647f788cf6" => :sierra
    sha256 "1a44cbdb4c7ee07150271ad72e9bf55f1edccce3e601e8d474dc80c033d38f35" => :el_capitan
    sha256 "1a44cbdb4c7ee07150271ad72e9bf55f1edccce3e601e8d474dc80c033d38f35" => :yosemite
  end

  depends_on :python3

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
