class Numpy < Formula
  desc "Package for scientific computing with Python"
  homepage "https://www.numpy.org/"
  url "https://files.pythonhosted.org/packages/2b/26/07472b0de91851b6656cbc86e2f0d5d3a3128e7580f23295ef58b6862d6c/numpy-1.16.1.zip"
  sha256 "31d3fe5b673e99d33d70cfee2ea8fe8dccd60f265c3ed990873a88647e3dd288"
  head "https://github.com/numpy/numpy.git"

  bottle do
    cellar :any
    sha256 "9542bce5982450e50992b906f42679f54213367a63c58f3951c8ee29e60420c5" => :mojave
    sha256 "f77add64f13be9d84f3b9a12c3595eded343e6258bd9a7624a67b09b69cc96e4" => :high_sierra
    sha256 "d72f29fb6c63200129908070c58d2893627f9bd601ae6e2d3a59f72b64546c73" => :sierra
  end

  depends_on "gcc" => :build # for gfortran
  depends_on "openblas"
  depends_on "python"
  depends_on "python@2"

  resource "Cython" do
    url "https://files.pythonhosted.org/packages/c1/f2/d1207fd0dfe5cb4dbb06a035eb127653821510d896ce952b5c66ca3dafa4/Cython-0.29.2.tar.gz"
    sha256 "2ac187ff998a95abb7fae452b5178f91e1a713698c9ced89836c94e6b1d3f41e"
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

    ["python2", "python3"].each do |python|
      version = Language::Python.major_minor_version python
      dest_path = lib/"python#{version}/site-packages"
      dest_path.mkpath

      nose_path = libexec/"nose/lib/python#{version}/site-packages"
      resource("nose").stage do
        system python, *Language::Python.setup_install_args(libexec/"nose")
        (dest_path/"homebrew-numpy-nose.pth").write "#{nose_path}\n"
      end

      ENV.prepend_create_path "PYTHONPATH", buildpath/"tools/lib/python#{version}/site-packages"
      resource("Cython").stage do
        system python, *Language::Python.setup_install_args(buildpath/"tools")
      end

      system python, "setup.py",
        "build", "--fcompiler=gnu95", "--parallel=#{ENV.make_jobs}",
        "install", "--prefix=#{prefix}",
        "--single-version-externally-managed", "--record=installed.txt"
    end
  end

  def caveats
    homebrew_site_packages = Language::Python.homebrew_site_packages
    user_site_packages = Language::Python.user_site_packages "python"
    <<~EOS
      If you use system python (that comes - depending on the OS X version -
      with older versions of numpy, scipy and matplotlib), you may need to
      ensure that the brewed packages come earlier in Python's sys.path with:
        mkdir -p #{user_site_packages}
        echo 'import sys; sys.path.insert(1, "#{homebrew_site_packages}")' >> #{user_site_packages}/homebrew.pth
    EOS
  end

  test do
    ["python2", "python3"].each do |python|
      system python, "-c", <<~EOS
        import numpy as np
        t = np.ones((3,3), int)
        assert t.sum() == 9
        assert np.dot(t, t).sum() == 27
      EOS
    end
  end
end
