class NumpyAT116 < Formula
  desc "Package for scientific computing with Python"
  homepage "https://www.numpy.org/"
  url "https://github.com/numpy/numpy/releases/download/v1.16.6/numpy-1.16.6.zip"
  sha256 "e5cf3fdf13401885e8eea8170624ec96225e2174eb0c611c6f26dd33b489e3ff"
  license "BSD-3-Clause"
  revision 1

  bottle do
    sha256 cellar: :any, arm64_monterey: "e740c127d61b149b3530b91b5b30763843f9245ac930f0bf7b53495371aa2c84"
    sha256 cellar: :any, arm64_big_sur:  "b2d618920646238a8711dba0c021600ea1153a50490ba3e379107fb3f96d0e77"
    sha256 cellar: :any, monterey:       "758a9c34c4e5d7b4f752b4ce60d9692c4f9c4219431b0eaeed202e3650e8de09"
    sha256 cellar: :any, big_sur:        "0b95667bfd54232190975066a1e70a0770b84d37129c3fcda418bbba34926c88"
    sha256 cellar: :any, catalina:       "fff9f604e35a06cc3197cc818a851d037f6d8f30df04fc7640144966bfb15c91"
    sha256 cellar: :any, mojave:         "0d6a4439397cf4c684b6e01fb7038ed9b9943582d5ef15f080503755330ca615"
    sha256 cellar: :any, high_sierra:    "ed8d4fa6634bea85689ae4d5e316e9a3546469e44358aba6a9f73183fdcb4272"
  end

  # was used only by opencv@2 which was deprecated on the same date
  # also uses Python 2 which is not supported anymore
  deprecate! date: "2015-02-01", because: :unsupported

  depends_on "gcc" => :build # for gfortran
  depends_on :macos # Due to Python 2
  depends_on "openblas"

  resource "Cython" do
    url "https://files.pythonhosted.org/packages/d9/82/d01e767abb9c4a5c07a6a1e6f4d5a8dfce7369318d31f48a52374094372e/Cython-0.29.15.tar.gz"
    sha256 "60d859e1efa5cc80436d58aecd3718ff2e74b987db0518376046adedba97ac30"
  end

  resource "nose" do
    url "https://files.pythonhosted.org/packages/58/a5/0dc93c3ec33f4e281849523a5a913fa1eea9a3068acfa754d44d88107a44/nose-1.3.7.tar.gz"
    sha256 "f1bffef9cbc82628f6e7d7b40d7e255aefaa1adb6a1b1d26c69a8b79e6208a98"
  end

  def install
    openblas = Formula["openblas"].opt_prefix
    ENV["ATLAS"] = "None" # avoid linking against Accelerate.framework
    ENV["BLAS"] = ENV["LAPACK"] = "#{openblas}/lib/libopenblas.dylib"

    config = <<~EOS
      [openblas]
      libraries = openblas
      library_dirs = #{openblas}/lib
      include_dirs = #{openblas}/include
    EOS

    Pathname("site.cfg").write config

    version = Language::Python.major_minor_version "python"
    dest_path = lib/"python#{version}/site-packages"
    dest_path.mkpath

    nose_path = libexec/"nose/lib/python#{version}/site-packages"
    resource("nose").stage do
      system "python", *Language::Python.setup_install_args(libexec/"nose")
      (dest_path/"homebrew-numpy-nose.pth").write "#{nose_path}\n"
    end

    ENV.prepend_create_path "PYTHONPATH", buildpath/"tools/lib/python#{version}/site-packages"
    resource("Cython").stage do
      system "python", *Language::Python.setup_install_args(buildpath/"tools")
    end

    system "python", "setup.py",
      "build", "--fcompiler=gnu95", "--parallel=#{ENV.make_jobs}",
      "install", "--prefix=#{prefix}",
      "--single-version-externally-managed", "--record=installed.txt"

    rm_f bin/"f2py" # avoid conflict with numpy
  end

  test do
    system "python", "-c", <<~EOS
      import numpy as np
      t = np.ones((3,3), int)
      assert t.sum() == 9
      assert np.dot(t, t).sum() == 27
    EOS
  end
end
