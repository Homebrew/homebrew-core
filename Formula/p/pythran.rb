class Pythran < Formula
  include Language::Python::Virtualenv

  desc "Ahead of Time compiler for numeric kernels"
  homepage "https://pythran.readthedocs.io/"
  url "https://files.pythonhosted.org/packages/bb/a3/03098a8a5d2c9f801c227cf941d85976934f5f47307ef3d819734370acdc/pythran-0.19.0.tar.gz"
  sha256 "18a096daa8b4bbe3ace06ce5d7325be5ff57aec4cf67b91834cf1b757b3e5392"
  license "BSD-3-Clause"
  head "https://github.com/serge-sans-paille/pythran.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "67ac72ad94168e18d5817877538317fbd52468bdf24a69112cd9118c25865d57"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "67ac72ad94168e18d5817877538317fbd52468bdf24a69112cd9118c25865d57"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "67ac72ad94168e18d5817877538317fbd52468bdf24a69112cd9118c25865d57"
    sha256 cellar: :any_skip_relocation, sonoma:        "d5a6ed5fc7e32827a8c770d06a3492fc4d1714e88b4ade02a47d306ab04c2288"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "67ac72ad94168e18d5817877538317fbd52468bdf24a69112cd9118c25865d57"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "67ac72ad94168e18d5817877538317fbd52468bdf24a69112cd9118c25865d57"
  end

  depends_on "gcc" => :test
  depends_on "boost" => :no_linkage
  depends_on "numpy"
  depends_on "openblas" => :no_linkage
  depends_on "python@3.14"
  depends_on "xsimd" => :no_linkage

  pypi_packages exclude_packages: "numpy"

  resource "beniget" do
    url "https://files.pythonhosted.org/packages/31/a9/cf7c2317da1f5034fdebe84555e14a474b3297ef2d03ad148ff02fef2e3a/beniget-0.5.0.tar.gz"
    sha256 "e7af11fa8ec7de3d3eb3d98b1e722d15d44017d8b35d8aa11d54f6719b312f22"
  end

  resource "gast" do
    url "https://files.pythonhosted.org/packages/91/f6/e73969782a2ecec280f8a176f2476149dd9dba69d5f8779ec6108a7721e6/gast-0.7.0.tar.gz"
    sha256 "0bb14cd1b806722e91ddbab6fb86bba148c22b40e7ff11e248974e04c8adfdae"
  end

  resource "ply" do
    url "https://files.pythonhosted.org/packages/e5/69/882ee5c9d017149285cab114ebeab373308ef0f874fcdac9beb90e0ac4da/ply-3.11.tar.gz"
    sha256 "00c7c1aaa88358b9c765b6d3000c6eec0ba42abca5351b095321aef446081da3"
  end

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/6d/44/f5da03a8ef95d369145c5bb53050e7877c9f3d312e128605fd9504829143/setuptools-84.0.0.tar.gz"
    sha256 "f4695c21257f0d9b537ec2692c941d02ee143b7cc1276941349a546573b2ef73"
  end

  def install
    # Remove bundled libraries
    rm_r(["pythran/boost", "pythran/xsimd"])

    # Help find Homebrew libraries at runtime even if unlinked
    deps_f = %w[boost openblas xsimd].map { |f| Formula[f] }
    include_dirs = [*deps_f.map(&:opt_include).select(&:directory?), HOMEBREW_PREFIX/"include"].join(" ")
    library_dirs = [*deps_f.map(&:opt_lib).select(&:directory?), HOMEBREW_PREFIX/"lib"].join(" ")
    cfgs = %w[darwin linux linux2].map { |os| "pythran/pythran-#{os}.cfg" }
    inreplace cfgs do |s|
      s.gsub!(/^include_dirs=/, "include_dirs=#{include_dirs}")
      s.gsub!(/^library_dirs=/, "library_dirs=#{library_dirs}")
    end

    virtualenv_install_with_resources
  end

  test do
    python3 = which("python3.14")

    (testpath/"test.py").write <<~PYTHON
      #pythran export b(int)
      import numpy
      def b(n):
        return numpy.ones((n, n)) @ numpy.ones((n, n))
    PYTHON

    (testpath/"arc_distance.py").write <<~PYTHON
      #pythran export arc_distance(float[], float[], float[], float[])
      import numpy as np
      def arc_distance(theta_1, phi_1, theta_2, phi_2):
        temp = np.sin((theta_2-theta_1)/2)**2 + np.cos(theta_1)*np.cos(theta_2)*np.sin((phi_2-phi_1)/2)**2
        distance_matrix = 2 * np.arctan2(np.sqrt(temp), np.sqrt(1-temp))
        return distance_matrix
    PYTHON

    system bin/"pythran", testpath/"test.py"
    with_env(CXX: "g++-#{Formula["gcc"].version.major}") do
      # Test common optimizations can be enabled. Using GCC as easier to enable OpenMP
      system bin/"pythran", "-DUSE_XSIMD", "-fopenmp", "-march=native", testpath/"arc_distance.py"
    end
    rm(Dir["*.py"])

    # Test OpenBLAS is correctly linked
    require "utils/linkage"
    openblas = Formula["openblas"].lib/shared_library("libblas")
    assert Utils.binary_linked_to_library?(testpath.glob("test.*.so").first, openblas), "Test not linked to OpenBLAS!"

    assert_equal <<~EOS, shell_output("#{python3} -c 'import test; print(test.b(3))'")
      [[3. 3. 3.]
       [3. 3. 3.]
       [3. 3. 3.]]
    EOS

    system python3, "-c", <<~PYTHON
      import numpy as np
      import arc_distance
      d = arc_distance.arc_distance(
        np.array([12.4,0.5,-5.6,12.34,9.21]), np.array([-5.6,3.4,2.3,-23.31,12.6]),
        np.array([3.45,1.5,55.4,567.0,43.2]), np.array([56.1,3.4,1.34,-56.9,-3.4]),
      )
      assert ([1.927, 1., 1.975, 1.83, 1.032] == np.round(d, 3)).all()
    PYTHON
  end
end
