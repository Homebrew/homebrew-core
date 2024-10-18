class Pythran < Formula
  include Language::Python::Virtualenv

  desc "Ahead of Time compiler for numeric kernels"
  homepage "https://pythran.readthedocs.io/"
  url "https://files.pythonhosted.org/packages/73/32/f892675c5009cd4c1895ded3d6153476bf00adb5ad1634d03635620881f5/pythran-0.16.1.tar.gz"
  sha256 "861748c0f9c7d422b32724b114b3817d818ed4eab86c09781aa0a3f7ceabb7f9"
  license "BSD-3-Clause"
  head "https://github.com/serge-sans-paille/pythran.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c102e65b23490ba1aa5a454f78991b83a5df12b28dcfdc80ef8deee1d612ef81"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c102e65b23490ba1aa5a454f78991b83a5df12b28dcfdc80ef8deee1d612ef81"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c102e65b23490ba1aa5a454f78991b83a5df12b28dcfdc80ef8deee1d612ef81"
    sha256 cellar: :any_skip_relocation, sonoma:         "1836a0fed68f565d8031c1e15449f8d322f9c0076570a1482466fcbd88f9c74d"
    sha256 cellar: :any_skip_relocation, ventura:        "1836a0fed68f565d8031c1e15449f8d322f9c0076570a1482466fcbd88f9c74d"
    sha256 cellar: :any_skip_relocation, monterey:       "1836a0fed68f565d8031c1e15449f8d322f9c0076570a1482466fcbd88f9c74d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1a390654163b4ce2a13919606c598bd6f61b412400ce5c7f899b568eedbb4c51"
  end

  depends_on "gcc" # for OpenMP
  depends_on "numpy"
  depends_on "openblas"
  depends_on "python@3.13"

  fails_with :clang # no OpenMP support

  resource "beniget" do
    url "https://files.pythonhosted.org/packages/2e/27/5bb01af8f2860d431b98d0721b96ff2cea979106cae3f2d093ec74f6400c/beniget-0.4.2.post1.tar.gz"
    sha256 "a0258537e65e7e14ec33a86802f865a667f949bb6c73646d55e42f7c45a052ae"
  end

  resource "gast" do
    url "https://files.pythonhosted.org/packages/f4/85/d65445079010a6bf35041455b7b97e1bfca49f80b8aed41f89f7831cb02d/gast-0.5.5.tar.gz"
    sha256 "5f4ae749ba7199034b6912af98f05b4058d6d48fc2f065037b241be819a22924"
  end

  resource "ply" do
    url "https://files.pythonhosted.org/packages/e5/69/882ee5c9d017149285cab114ebeab373308ef0f874fcdac9beb90e0ac4da/ply-3.11.tar.gz"
    sha256 "00c7c1aaa88358b9c765b6d3000c6eec0ba42abca5351b095321aef446081da3"
  end

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/27/b8/f21073fde99492b33ca357876430822e4800cdf522011f18041351dfa74b/setuptools-75.1.0.tar.gz"
    sha256 "d59a21b17a275fb872a9c3dae73963160ae079f1049ed956880cd7c09b120538"
  end

  def python3
    which("python3.13")
  end

  def install
    if OS.mac?
      gcc_major_ver = Formula["gcc"].any_installed_version.major
      inreplace "pythran/pythran-darwin.cfg" do |s|
        s.gsub!(/^include_dirs=/, "include_dirs=#{Formula["openblas"].opt_include}")
        s.gsub!(/^library_dirs=/, "library_dirs=#{Formula["openblas"].opt_lib}")
        s.gsub!(/^blas=.*/, "blas=openblas")
        s.gsub!(/^CC=.*/, "CC=#{Formula["gcc"].opt_bin}/gcc-#{gcc_major_ver}")
        s.gsub!(/^CXX=.*/, "CXX=#{Formula["gcc"].opt_bin}/g++-#{gcc_major_ver}")
      end
    end

    virtualenv_install_with_resources
  end

  test do
    pythran = Formula["pythran"].opt_bin/"pythran"

    (testpath/"dprod.py").write <<~EOS
      #pythran export dprod(int list, int list)
      def dprod(arr0, arr1):
        return sum([x*y for x,y in zip(arr0, arr1)])
    EOS
    system pythran, testpath/"dprod.py"
    rm(testpath/"dprod.py")

    assert_equal "11", shell_output("#{python3} -c 'import dprod; print(dprod.dprod([1,2], [3,4]))'").chomp

    (testpath/"arc_distance.py").write <<~EOS
      #pythran export arc_distance(float[], float[], float[], float[])
      import numpy as np
      def arc_distance(theta_1, phi_1, theta_2, phi_2):
        """
        Calculates the pairwise arc distance between all points in vector a and b.
        """
        temp = np.sin((theta_2-theta_1)/2)**2 + np.cos(theta_1)*np.cos(theta_2)*np.sin((phi_2-phi_1)/2)**2
        distance_matrix = 2 * np.arctan2(np.sqrt(temp), np.sqrt(1-temp))
        return distance_matrix
    EOS
    # Test with configured gcc to detect breakages from gcc major versions and for OpenMP support
    system pythran, "-DUSE_XSIMD", "-fopenmp", "-march=native", testpath/"arc_distance.py"
    rm(testpath/"arc_distance.py")

    system python3, "-c", <<~EOS
      import numpy as np
      import arc_distance
      d = arc_distance.arc_distance(
        np.array([12.4,0.5,-5.6,12.34,9.21]), np.array([-5.6,3.4,2.3,-23.31,12.6]),
        np.array([3.45,1.5,55.4,567.0,43.2]), np.array([56.1,3.4,1.34,-56.9,-3.4]),
      )
      assert ([1.927, 1., 1.975, 1.83, 1.032] == np.round(d, 3)).all()
    EOS
  end
end
