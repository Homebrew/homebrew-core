class Fades < Formula
  desc "Automatically handle virtualenvs for python scripts"
  homepage "https://fades.readthedocs.org/"
  url "https://pypi.python.org/packages/source/f/fades/fades-5.tar.gz"
  sha256 "1952f496059ba6bac535f2c07effae44a55de0654ababaa1a15879c4b3fa89c1"

  head "https://github.com/PyAr/fades.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "03c99b08cf910903a08e1fdb45c8e359b419e32d5dceaa924a4731b8a9299b8d" => :el_capitan
    sha256 "b1de3519ca9423da3344d84afcfcb9fd7d8a9ea8e65064a075d8df77da3a8d93" => :yosemite
    sha256 "2bc897cf9b5d4c54261fff90e0fd519010de4784b8024538cc7bcd71158c2781" => :mavericks
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
