class Numpy < Formula
  desc "Package for scientific computing with Python"
  homepage "http://www.numpy.org"
  url "https://files.pythonhosted.org/packages/bf/2d/005e45738ab07a26e621c9c12dc97381f372e06678adf7dc3356a69b5960/numpy-1.13.3.zip"
  sha256 "36ee86d5adbabc4fa2643a073f93d5504bdfed37a149a3a49f4dde259f35a750"

  bottle do
    sha256 "44b42ff9b9adcb0b1529568174fdb943737403df45ad0f743d6a74757caad183" => :high_sierra
    sha256 "2b07c8f8a10351deafeb6e8d3bb7a667a02e93d4b7d17545c3c318118c1fae22" => :sierra
    sha256 "6347719f2b90ad714e2e4f63820d224a9505ccd97abe04fe47435126bcd20df8" => :el_capitan
  end

  head do
    url "https://github.com/numpy/numpy.git"

    resource "Cython" do
      url "https://files.pythonhosted.org/packages/94/63/f54920c2ddbe3e1341a4c268f7091bf1bf53c3d84f4b115aa5beea64aef9/Cython-0.27.tar.gz"
      sha256 "b932b5194e87a8b853d493dc1b46e38632d6846a86f55b8346eb9c6ec3bdc00b"
    end
  end

  option "without-python", "Build without python2 support"

  depends_on :fortran => :build
  depends_on :python => :recommended if MacOS.version <= :snow_leopard
  depends_on :python3 => :recommended

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
    if build.with?("python") && !Formula["python"].installed?
      homebrew_site_packages = Language::Python.homebrew_site_packages
      user_site_packages = Language::Python.user_site_packages "python"
      <<-EOS.undent
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
      system python, "-c", <<-EOS.undent
        import numpy as np
        t = np.ones((3,3), int)
        assert t.sum() == 9
        assert np.dot(t, t).sum() == 27
      EOS
    end
  end
end
