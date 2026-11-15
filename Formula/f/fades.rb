class Fades < Formula
  desc "Automatically handle virtualenvs for python scripts"
  homepage "https://fades.readthedocs.io/"
  # TODO: Check if possible to migrate to `virtualenv_install_with_resources`
  # https://github.com/PyAr/fades/issues/425
  url "https://files.pythonhosted.org/packages/8b/e8/87a44f1c33c41d1ad6ee6c0b87e957bf47150eb12e9f62cc90fdb6bf8669/fades-9.0.2.tar.gz"
  sha256 "4a2212f48c4c377bbe4da376c4459fe2d79aea2e813f0cb60d9b9fdf43d205cc"
  license "GPL-3.0-only"
  revision 4
  head "https://github.com/PyAr/fades.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "c0a1d259e0f9e789706a9da7efd2f16d56d66d615d88b3230ea182bbfb3cb73c"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "c0a1d259e0f9e789706a9da7efd2f16d56d66d615d88b3230ea182bbfb3cb73c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "c0a1d259e0f9e789706a9da7efd2f16d56d66d615d88b3230ea182bbfb3cb73c"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "be85b7547e05eba3b20431a0785804e633611d26a7c035f05b69124c54b44f3e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "be85b7547e05eba3b20431a0785804e633611d26a7c035f05b69124c54b44f3e"
  end

  depends_on "python@3.15"

  pypi_packages extra_packages: %w[packaging]

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/7d/fa/3944b40b07da9ce895c0e6303a5ab7d53da063554f534556b134a54d6093/packaging-26.3.tar.gz"
    sha256 "94edc256424af38762eb31306eed28beb9f0efc50a8837492c9d6fd6004aed79"
  end

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/70/b3/c19426f783614d625699a4b247faf628ea9ab1db228674491767b417f9e1/setuptools-84.2.1.tar.gz"
    sha256 "3ff8b3b5492a0aa66960f4419365a86b84e013070d4313e4d4a6894f5d64d6bc"
  end

  # Backport switch from removed `pkg_resources` to `packaging`
  patch do
    file "Patches/fades/drop-pkg_resources.patch"
    type :backport
    resolves "https://github.com/PyAr/fades/pull/432"
  end

  def install
    ENV.append_path "PYTHONPATH", libexec/Language::Python.site_packages(python3)

    resources.each do |r|
      r.stage do
        system python3, "-m", "pip", "install", *std_pip_args(prefix: libexec, build_isolation: true), "."
      end
    end
    system python3, "-m", "pip", "install", *std_pip_args(prefix: libexec), "."
    (bin/"fades").write_env_script(libexec/"bin/fades", PYTHONPATH: ENV["PYTHONPATH"])

    man1.install buildpath/"man/fades.1"
    rm(libexec/"bin/fades.cmd") # remove windows cmd file
  end

  test do
    (testpath/"test.py").write("print('it works')")
    system bin/"fades", testpath/"test.py"
  end
end
