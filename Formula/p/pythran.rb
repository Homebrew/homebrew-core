class Pythran < Formula
  include Language::Python::Virtualenv

  desc "Ahead of Time compiler for numeric kernels"
  homepage "https://pythran.readthedocs.io/"
  url "https://files.pythonhosted.org/packages/d4/84/17c4c44a24f5ec709991e603e601bf316d09c4fe915fbe348c689dede998/pythran-0.18.1.tar.gz"
  sha256 "8803ed948bf841a11bbbb10472a8ff6ea24ebd70e67c3f77b77be3db900eccfe"
  license "BSD-3-Clause"
  revision 1
  head "https://github.com/serge-sans-paille/pythran.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7d6f54c0238dc14c132d08adfb73ccfd2e4da315eb7a29ee20c5ff526a50bfc1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7d6f54c0238dc14c132d08adfb73ccfd2e4da315eb7a29ee20c5ff526a50bfc1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7d6f54c0238dc14c132d08adfb73ccfd2e4da315eb7a29ee20c5ff526a50bfc1"
    sha256 cellar: :any_skip_relocation, sonoma:        "ef2730ba9293e4b7b56aa9c4968e1aa5affd28e8a8407b4558a87da371b0caf6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7d6f54c0238dc14c132d08adfb73ccfd2e4da315eb7a29ee20c5ff526a50bfc1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7d6f54c0238dc14c132d08adfb73ccfd2e4da315eb7a29ee20c5ff526a50bfc1"
  end

  depends_on "gcc" => :test
  depends_on "boost" => :no_linkage
  depends_on "numpy"
  depends_on "openblas" => :no_linkage
  depends_on "python@3.14"
  depends_on "xsimd" => :no_linkage

  pypi_packages exclude_packages: "numpy"

  resource "beniget" do
    url "https://files.pythonhosted.org/packages/2e/27/5bb01af8f2860d431b98d0721b96ff2cea979106cae3f2d093ec74f6400c/beniget-0.4.2.post1.tar.gz"
    sha256 "a0258537e65e7e14ec33a86802f865a667f949bb6c73646d55e42f7c45a052ae"
  end

  resource "gast" do
    url "https://files.pythonhosted.org/packages/3c/14/c566f5ca00c115db7725263408ff952b8ae6d6a4e792ef9c84e77d9af7a1/gast-0.6.0.tar.gz"
    sha256 "88fc5300d32c7ac6ca7b515310862f71e6fdf2c029bbec7c66c0f5dd47b6b1fb"
  end

  resource "ply" do
    url "https://files.pythonhosted.org/packages/e5/69/882ee5c9d017149285cab114ebeab373308ef0f874fcdac9beb90e0ac4da/ply-3.11.tar.gz"
    sha256 "00c7c1aaa88358b9c765b6d3000c6eec0ba42abca5351b095321aef446081da3"
  end

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/34/26/f5d29e25ffdb535afef2d35cdb55b325298f96debd670da4c325e08d70f4/setuptools-83.0.0.tar.gz"
    sha256 "025bccbbf0fa05b6192bc64ae1e7b16e001fd6d6d4d5de03c97b1c1ade523bef"
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
