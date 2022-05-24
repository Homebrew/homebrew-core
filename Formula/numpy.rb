class Numpy < Formula
  desc "Package for scientific computing with Python"
  homepage "https://www.numpy.org/"
  url "https://files.pythonhosted.org/packages/f6/d8/ab692a75f584d13c6542c3994f75def5bce52ded9399f52e230fe402819d/numpy-1.22.4.zip"
  sha256 "425b390e4619f58d8526b3dcf656dde069133ae5c240229821f01b5f44ea07af"
  license "BSD-3-Clause"
  head "https://github.com/numpy/numpy.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_monterey: "1d79af6c8ad548afd40acbfb84b6aa5539d346f36785ab634e5720b7ec1648ac"
    sha256 cellar: :any, arm64_big_sur:  "b81fc1b691906a6be063853f445f303a212bef7818650d5f6e6d3b3c25eaa104"
    sha256 cellar: :any, monterey:       "cfd6757ff155ac67c7866b018a031a0849f86ac115892ed2dd0860489c462b4b"
    sha256 cellar: :any, big_sur:        "6006e3e63e1132ca157df9e1921e8a888580cc715a94d6586ca1ba98a2a4c919"
    sha256 cellar: :any, catalina:       "c1bf9ef0b8c95223b3fb60bc60b28fc857729aafc15d61926ea9f5fb0294f0cd"
    sha256               x86_64_linux:   "34db1f2d5ef4cb7cc419b1715a0398db30821e90b4779e694c7e5fa7f9f50924"
  end

  depends_on "gcc" => :build # for gfortran
  depends_on "libcython" => :build
  depends_on "python@3.10" => [:build, :test]
  depends_on "python@3.9" => [:build, :test]
  depends_on "openblas"

  fails_with gcc: "5"

  def pythons
    deps.map(&:to_formula)
        .select { |f| f.name.match?(/python@\d\.\d+/) }
        .map(&:opt_bin)
        .map { |bin| bin/"python3" }
  end

  def install
    openblas = Formula["openblas"].opt_prefix
    ENV["ATLAS"] = "None" # avoid linking against Accelerate.framework
    ENV["BLAS"] = ENV["LAPACK"] = "#{openblas}/lib/#{shared_library("libopenblas")}"

    config = <<~EOS
      [openblas]
      libraries = openblas
      library_dirs = #{openblas}/lib
      include_dirs = #{openblas}/include
    EOS

    Pathname("site.cfg").write config

    pythons.each do |python|
      xy = Language::Python.major_minor_version python
      ENV.prepend_create_path "PYTHONPATH", Formula["libcython"].opt_libexec/"lib/python#{xy}/site-packages"

      system python, "setup.py", "build",
             "--fcompiler=#{Formula["gcc"].opt_bin}/gfortran", "--parallel=#{ENV.make_jobs}"
      system python, *Language::Python.setup_install_args(prefix),
                     "--install-lib=#{prefix/Language::Python.site_packages(python)}"
    end
  end

  test do
    pythons.each do |python|
      system python, "-c", <<~EOS
        import numpy as np
        t = np.ones((3,3), int)
        assert t.sum() == 9
        assert np.dot(t, t).sum() == 27
      EOS
    end
  end
end
