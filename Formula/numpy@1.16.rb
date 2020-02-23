class NumpyAT116 < Formula
  desc "Package for scientific computing with Python"
  homepage "https://www.numpy.org/"
  url "https://github.com/numpy/numpy/releases/download/v1.16.6/numpy-1.16.6.zip"
  sha256 "e5cf3fdf13401885e8eea8170624ec96225e2174eb0c611c6f26dd33b489e3ff"

  bottle do
    cellar :any
    sha256 "6c80a9d89e01c944f4142c95f7239d796c9e0a4915c395e99a30d8b221c89280" => :catalina
    sha256 "eae10fb059b9246e2e106572c0534b33fe5848380b945fb2afe90600b0dc5cb1" => :mojave
    sha256 "d7713fb06785ea6dc8ff901858b7c5155f4ca5624d4c5d380b58c1f254ac6268" => :high_sierra
  end

  depends_on "gcc" => :build # for gfortran
  depends_on "openblas"
  uses_from_macos "python@2"

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
