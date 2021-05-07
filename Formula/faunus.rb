class Faunus < Formula
  include Language::Python::Virtualenv

  desc "Framework for Metropolis Monte Carlo Simulation of Molecular Systems"
  homepage "https://mlund.github.io/faunus"
  url "https://github.com/mlund/faunus/archive/522213d.tar.gz"
  version "2.5.0"
  sha256 "d7b3d6bfddafa808fd21108c916583c850719d736a2f344aac3ab6088d2d72cc"
  license "MIT"

  depends_on "cmake" => :build
  depends_on "libtool" => :build
  depends_on "open-mpi"
  depends_on "python@3.9"

  resource "markupsafe" do
    url "https://files.pythonhosted.org/packages/b9/2e/64db92e53b86efccfaea71321f597fa2e1b2bd3853d8ce658568f7a13094/MarkupSafe-1.1.1.tar.gz"
    sha256 "29872e92839765e546828bb7754a68c418d927cd064fd4708fab9fe9c8bb116b"
  end
  resource "six" do
    url "https://files.pythonhosted.org/packages/6b/34/415834bfdafca3c5f451532e8a8d9ba89a21c9743a0c59fbd0205c7f9426/six-1.15.0.tar.gz"
    sha256 "30639c035cdb23534cd4aa2dd52c3bf48f06e5f4a941509c8bafd8ce11080259"
  end
  resource "pyrsistent" do
    url "https://files.pythonhosted.org/packages/4d/70/fd441df751ba8b620e03fd2d2d9ca902103119616f0f6cc42e6405035062/pyrsistent-0.17.3.tar.gz"
    sha256 "2e636185d9eb976a18a8a8e96efce62f2905fea90041958d8cc2a189756ebf3e"
  end
  resource "attrs" do
    url "https://files.pythonhosted.org/packages/f0/cb/80a4a274df7da7b8baf083249b0890a0579374c3d74b5ac0ee9291f912dc/attrs-20.3.0.tar.gz"
    sha256 "832aa3cde19744e49938b91fea06d69ecb9e649c93ba974535d08ad92164f700"
  end
  resource "Jinja2" do
    url "https://files.pythonhosted.org/packages/4f/e7/65300e6b32e69768ded990494809106f87da1d436418d5f1367ed3966fd7/Jinja2-2.11.3.tar.gz"
    sha256 "a6d58433de0ae800347cab1fa3043cebbabe8baa9d29e668f1c768cb87a333c6"
  end
  resource "jsonschema" do
    url "https://files.pythonhosted.org/packages/69/11/a69e2a3c01b324a77d3a7c0570faa372e8448b666300c4117a516f8b1212/jsonschema-3.2.0.tar.gz"
    sha256 "c8a85b28d377cc7737e46e2d9f2b4f44ee3c0e1deac6bf46ddefc7187d30797a"
  end
  resource "ruamel.yaml" do
    url "https://files.pythonhosted.org/packages/9a/ee/55cd64bbff971c181e2d9e1c13aba9a27fd4cd2bee545dbe90c44427c757/ruamel.yaml-0.15.100.tar.gz"
    sha256 "8e42f3067a59e819935a2926e247170ed93c8f0b2ab64526f888e026854db2e4"
  end

  def install
    venv_root = libexec/"venv"
    xy = Language::Python.major_minor_version "python3"
    ENV.prepend_create_path "PYTHONPATH", "#{venv_root}/lib/python#{xy}/site-packages"
    venv = virtualenv_create(venv_root, "python3")
    venv.pip_install resources
    system "cmake",
      "-DENABLE_OPENMP=off",
      "-DENABLE_MPI=on",
      "-DENABLE_PYTHON=on",
      "-DVERSION_STRING=v#{version}",
      "-S", ".", *std_cmake_args,
      "-DPYTHON_EXECUTABLE=#{venv_root}/bin/python"
    system "make", "install"
    mv prefix/"bin/yason.py", prefix/"bin/yason.py.unwrapped"
    (bin/"yason.py").write_env_script prefix/"bin/yason.py.unwrapped",
      PYTHONPATH: "#{venv_root}/lib/python#{xy}/site-packages"
  end

  test do
    system "#{bin}/yason.py #{share}/faunus/examples/minimal.yml | #{bin}/faunus --quiet"
    system "#{bin}/faunus", "test"
  end
end
