class Fades < Formula
  desc "Automatically handle virtualenvs for python scripts"
  homepage "https://fades.readthedocs.org/"
  url "https://files.pythonhosted.org/packages/8b/9c/fd93dff7d8665b704c2f008009876118971df691f8e5bd662befdb8f574c/fades-8.1.tar.gz"
  sha256 "c9ba065b59e9b6a2ab6fb6f65cd71a17e9fc97f543d5c975a4f9841a51d49317"
  head "https://github.com/PyAr/fades.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "568d9c2abc721d568e81c2b2c9c00d18323cf72597cdb2a2e22786a3416ee834" => :mojave
    sha256 "1ba996deb40bae3649bb34d3fbd73495979daf805cdfa48c7f0c423b64675fa2" => :high_sierra
    sha256 "1ba996deb40bae3649bb34d3fbd73495979daf805cdfa48c7f0c423b64675fa2" => :sierra
    sha256 "2de71da4212f19ffb8373f0f334d7534adf512bc14de942d32ffc3390b4c14f8" => :el_capitan
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
