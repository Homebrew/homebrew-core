class Fades < Formula
  desc "Automatically handle virtualenvs for python scripts"
  homepage "https://fades.readthedocs.org/"
  url "https://files.pythonhosted.org/packages/8b/9c/fd93dff7d8665b704c2f008009876118971df691f8e5bd662befdb8f574c/fades-8.1.tar.gz"
  sha256 "c9ba065b59e9b6a2ab6fb6f65cd71a17e9fc97f543d5c975a4f9841a51d49317"
  head "https://github.com/PyAr/fades.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "ab04a2d9b55a1a2c5266b039c3f0f88a2d44625be4a34b98adba3a639c6c1638" => :catalina
    sha256 "c21bbc27f3219e06672b379c38b065808bc9b32301d8d334e0556721aac2b654" => :mojave
    sha256 "6c4ee1dadfb942d489a91e6dd14f9b71fbab8962fed4a0e454456331cd2fc8c1" => :high_sierra
    sha256 "4df027cd197638de99378de8d7e0c91f6fa4fbbd685440dca7df1363d32529f6" => :sierra
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
