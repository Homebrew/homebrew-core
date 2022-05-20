class Numpy < Formula
  desc "Package for scientific computing with Python"
  homepage "https://www.numpy.org/"
  url "https://files.pythonhosted.org/packages/64/4a/b008d1f8a7b9f5206ecf70a53f84e654707e7616a771d84c05151a4713e9/numpy-1.22.3.zip"
  sha256 "dbc7601a3b7472d559dc7b933b18b4b66f9aa7452c120e87dfb33d02008c8a18"
  license "BSD-3-Clause"
  revision 1
  head "https://github.com/numpy/numpy.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_monterey: "a1c754b946a507ea528ad0962cfc1fbf0d57c22903ae5695b12e17c94136aeda"
    sha256 cellar: :any, arm64_big_sur:  "8750797b418d638eb4fb446f5a903cf96a36dfb580036556a1001edf27ace95f"
    sha256 cellar: :any, monterey:       "78446dd95fdf20270dae3979bf92f25c182a9d3e2d1bf820dc2ca63caa9d1738"
    sha256 cellar: :any, big_sur:        "74ba91b3faa4b5b4aa5cf801c62c1338f8f8ce736af04259626e008af7783a2f"
    sha256 cellar: :any, catalina:       "f81c38efd05d1d93dfdb9ffaedea3c820bb922dea9e00ac77f85e67192fe7226"
    sha256               x86_64_linux:   "f81bff8b8ceaf84423734a780c65a9fc69235c905206c8aece6b6a8b0761bb8a"
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
