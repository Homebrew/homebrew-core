class Numpy < Formula
  desc "Package for scientific computing with Python"
  homepage "https://www.numpy.org/"
  url "https://files.pythonhosted.org/packages/d3/4b/f9f4b96c0b1ba43d28a5bdc4b64f0b9d3fbcf31313a51bc766942866a7c7/numpy-1.16.4.zip"
  sha256 "7242be12a58fec245ee9734e625964b97cf7e3f2f7d016603f9e56660ce479c7"
  head "https://github.com/numpy/numpy.git"

  bottle do
    cellar :any
    sha256 "d1a6b200ef06b691881d2dce01ba40f4b18be032bd8fb75fdec6b098440d7cf5" => :mojave
    sha256 "88c5beef3c5c539ba8991cd87625e5e9ae6608f6e0c67f0fbd7c39552d28fcd8" => :high_sierra
    sha256 "58e0581edfb56698159e2d85b774219a0157bff5b9d11a7e01f034537d0c3f6e" => :sierra
  end

  depends_on "gcc" => :build # for gfortran
  depends_on "openblas"
  depends_on "python"
  depends_on "python@2"

  resource "Cython" do
    url "https://files.pythonhosted.org/packages/69/ab/b18f7f2e61c12e5e859c86b6d37f73971679d5f5c5c97d6cc7ff8916468a/Cython-0.29.9.tar.gz"
    sha256 "b88e033c06d29f3f3c760a3fb9837dce6e124d627bd562d1cdf93e9da16df215"
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
