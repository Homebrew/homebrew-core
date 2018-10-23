class Numpy < Formula
  desc "Package for scientific computing with Python"
  homepage "https://www.numpy.org/"
  url "https://files.pythonhosted.org/packages/83/6b/d03277eacf113697675cd659086a4dcf9472108e2f1a83884c0271bdca46/numpy-1.15.3.zip"
  sha256 "1c0c80e74759fa4942298044274f2c11b08c86230b25b8b819e55e644f5ff2b6"

  bottle do
    sha256 "fd06e65851fca8ee9d06cdefa4ff6fd6e1ac0d404cde94b0a95bc1b90d69fe66" => :mojave
    sha256 "0928c6950db0b3976ebc87ccefb836fe89d32a427c6cbf1c7081ef7f5a3baf22" => :high_sierra
    sha256 "474e492961f9b2871f58725fdd26bef8c7270930d3406224b3a71ad2a0d4b629" => :sierra
  end

  head do
    url "https://github.com/numpy/numpy.git"

    resource "Cython" do
      url "https://files.pythonhosted.org/packages/f0/66/6309291b19b498b672817bd237caec787d1b18013ee659f17b1ec5844887/Cython-0.29.tar.gz"
      sha256 "94916d1ede67682638d3cc0feb10648ff14dc51fb7a7f147f4fedce78eaaea97"
    end
  end

  option "without-python@2", "Build without python2 support"

  depends_on "gcc" => :build # for gfortran
  depends_on "openblas"
  depends_on "python" => :recommended
  depends_on "python@2" => :recommended

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

    Language::Python.each_python(build) do |python, version|
      dest_path = lib/"python#{version}/site-packages"
      dest_path.mkpath

      nose_path = libexec/"nose/lib/python#{version}/site-packages"
      resource("nose").stage do
        system python, *Language::Python.setup_install_args(libexec/"nose")
        (dest_path/"homebrew-numpy-nose.pth").write "#{nose_path}\n"
      end

      if build.head?
        ENV.prepend_create_path "PYTHONPATH", buildpath/"tools/lib/python#{version}/site-packages"
        resource("Cython").stage do
          system python, *Language::Python.setup_install_args(buildpath/"tools")
        end
      end

      system python, "setup.py",
        "build", "--fcompiler=gnu95", "--parallel=#{ENV.make_jobs}",
        "install", "--prefix=#{prefix}",
        "--single-version-externally-managed", "--record=installed.txt"
    end
  end

  def caveats
    if build.with?("python@2") && !Formula["python@2"].installed?
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
  end

  test do
    Language::Python.each_python(build) do |python, _version|
      system python, "-c", <<~EOS
        import numpy as np
        t = np.ones((3,3), int)
        assert t.sum() == 9
        assert np.dot(t, t).sum() == 27
      EOS
    end
  end
end
