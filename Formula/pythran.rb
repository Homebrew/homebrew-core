class Pythran < Formula
  include Language::Python::Virtualenv

  desc "Ahead of Time compiler for numeric kernels"
  homepage "https://pythran.readthedocs.io/"
  url "https://files.pythonhosted.org/packages/c6/e6/986a967dcca91d89e36f4d4a2f69a052030bce01a7cd48a6b7fba1a50189/pythran-0.9.12.post1.tar.gz"
  sha256 "e7589cf83b0befa9a1b55e98223caf89aff887d9e3f14be912cf8703a717f185"
  license "BSD-3-Clause"
  head "https://github.com/serge-sans-paille/pythran.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "eb3289e9d8326e8ac6b2df366e9ef20245d2c830f166044a6f110f4e87dd5291"
    sha256 cellar: :any_skip_relocation, big_sur:       "74ebdde670663491d2c5c590159de3f655c9b36110dc223cfe06c64f06003cae"
    sha256 cellar: :any_skip_relocation, catalina:      "74ebdde670663491d2c5c590159de3f655c9b36110dc223cfe06c64f06003cae"
    sha256 cellar: :any_skip_relocation, mojave:        "74ebdde670663491d2c5c590159de3f655c9b36110dc223cfe06c64f06003cae"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ecbf76fbaa393c2b28143bb5d2c6cc0461d798ba9bb56fa3ab380538fccdf409"
  end

  depends_on "gcc" # for OpenMP
  depends_on "numpy"
  depends_on "openblas"
  depends_on "python@3.9"
  depends_on "six"

  resource "beniget" do
    url "https://files.pythonhosted.org/packages/14/e7/50cbac38f77eca8efd39516be6651fdb9f3c4c0fab8cf2cf05f612578737/beniget-0.4.1.tar.gz"
    sha256 "75554b3b8ad0553ce2f607627dad3d95c60c441189875b98e097528f8e23ac0c"
  end

  resource "gast" do
    url "https://files.pythonhosted.org/packages/53/88/e12484298c9c913b68c1de191fa673f8a976036d98efbdcb60014f14c65c/gast-0.5.2.tar.gz"
    sha256 "f81fcefa8b982624a31c9e4ec7761325a88a0eba60d36d1da90e47f8fe3c67f7"
  end

  resource "ply" do
    url "https://files.pythonhosted.org/packages/e5/69/882ee5c9d017149285cab114ebeab373308ef0f874fcdac9beb90e0ac4da/ply-3.11.tar.gz"
    sha256 "00c7c1aaa88358b9c765b6d3000c6eec0ba42abca5351b095321aef446081da3"
  end

  def install
    on_macos do
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
    python = Formula["python@3.9"].opt_bin/"python3"

    (testpath/"dprod.py").write <<~EOS
      #pythran export dprod(int list, int list)
      def dprod(arr0, arr1):
        return sum([x*y for x,y in zip(arr0, arr1)])
    EOS
    system pythran, testpath/"dprod.py"
    rm_f testpath/"dprod.py"
    assert_equal "11", shell_output("#{python} -c 'import dprod; print(dprod.dprod([1,2], [3,4]))'").chomp

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
    with_env(CC: nil, CXX: nil) do
      system pythran, "-DUSE_XSIMD", "-fopenmp", "-march=native", testpath/"arc_distance.py"
    end
    rm_f testpath/"arc_distance.py"
    system python, "-c", <<~EOS
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
