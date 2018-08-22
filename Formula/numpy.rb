class Numpy < Formula
  desc "Package for scientific computing with Python"
  homepage "https://www.numpy.org/"
  url "https://files.pythonhosted.org/packages/65/ab/4dfcc20234fae12ee40c714b98077d6e3a10652496bd1488fa4828529b22/numpy-1.15.1.zip"
  sha256 "7b9e37f194f8bcdca8e9e6af92e2cbad79e360542effc2dd6b98d63955d8d8a3"

  bottle do
    sha256 "e26fdc4e56f65f5afd875156556c8975ddeda418e5b37727ab535f4b2dba088e" => :high_sierra
    sha256 "a15fc000cd2d90c579efaff1b5c7fe4f1377651dd8cf2712466619748c63d315" => :sierra
    sha256 "7d1c17824da21bf5c0555751e0721d4be9f3281b4791dcdd8f9c8f3aa83db818" => :el_capitan
  end

  head do
    url "https://github.com/numpy/numpy.git"

    resource "Cython" do
      url "https://files.pythonhosted.org/packages/21/89/ca320e5b45d381ae0df74c4b5694f1471c1b2453c5eb4bac3449f5970481/Cython-0.28.5.tar.gz"
      sha256 "b64575241f64f6ec005a4d4137339fb0ba5e156e826db2fdb5f458060d9979e0"
    end
  end

  option "without-python@2", "Build without python2 support"

  depends_on "gcc" => :build # for gfortran
  depends_on "python@2" => :recommended
  depends_on "python" => :recommended

  resource "nose" do
    url "https://files.pythonhosted.org/packages/58/a5/0dc93c3ec33f4e281849523a5a913fa1eea9a3068acfa754d44d88107a44/nose-1.3.7.tar.gz"
    sha256 "f1bffef9cbc82628f6e7d7b40d7e255aefaa1adb6a1b1d26c69a8b79e6208a98"
  end

  def install
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
