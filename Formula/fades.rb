class Fades < Formula
  desc "Automatically handle virtualenvs for python scripts"
  homepage "https://fades.readthedocs.io/"
  url "https://files.pythonhosted.org/packages/8b/e8/87a44f1c33c41d1ad6ee6c0b87e957bf47150eb12e9f62cc90fdb6bf8669/fades-9.0.2.tar.gz"
  sha256 "4a2212f48c4c377bbe4da376c4459fe2d79aea2e813f0cb60d9b9fdf43d205cc"
  license "GPL-3.0-only"
  head "https://github.com/PyAr/fades.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "51586193401133346c21af2e39a4560e7d7e2e375eaeb0aa0d036a79f824ebec"
  end

  depends_on "python@3.10"

  def install
    site_packages = libexec/Language::Python.site_packages("python3")
    ENV.prepend_create_path "PYTHONPATH", site_packages
    system "python3", *Language::Python.setup_install_args(libexec), "--install-lib=#{site_packages}"

    bin.install Dir[libexec/"bin/*"]
    bin.env_script_all_files(libexec/"bin", PYTHONPATH: ENV["PYTHONPATH"])
  end

  test do
    (testpath/"test.py").write("print('it works')")
    system "#{bin}/fades", testpath/"test.py"
  end
end
