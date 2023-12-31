class Pythran < Formula
  include Language::Python::Virtualenv

  desc "Ahead of Time compiler for numeric kernels"
  homepage "https://pythran.readthedocs.io/"
  url "https://files.pythonhosted.org/packages/2c/ab/a647b8cc3ac1aa07cde06875157696e4522958fb8363474bce21c302d4d8/pythran-0.14.0.tar.gz"
  sha256 "42f3473946205964844eff7f750e2541afb2006d53475d708f5ff2d048db89bd"
  license "BSD-3-Clause"
  revision 1
  head "https://github.com/serge-sans-paille/pythran.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0eddf90ccf8b375979890692b2055c412b020cdec739710d40042aa18ec60bc5"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a4cb4b32cf519de7cb726262ba8178c1194e49c203ee307f5c083963f945b955"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7954217dba20328512b364cbf043791ee7b9835657de06f2b2b8a864841d393d"
    sha256 cellar: :any_skip_relocation, sonoma:         "9f6f5ce60efa42ebc691856159aa77f1027393d4fe10d63789a594e7f76c3a6c"
    sha256 cellar: :any_skip_relocation, ventura:        "f958f656b096eb14c0894361abd1fca548b3c4d784949c7d0828a918702c6d37"
    sha256 cellar: :any_skip_relocation, monterey:       "06979055ae2124484c3449bbd5939b721e7c8bd6778e081d8ee164f26415b054"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f5ebfa109ac5bf54d5de07fab269dfbfaf4363b7d4383a113c7ddd72f3a373a2"
  end

  depends_on "python@3.11" => [:build, :test]
  depends_on "python@3.12" => [:build, :test]
  depends_on "gcc" # for OpenMP
  depends_on "numpy"
  depends_on "openblas"
  depends_on "python-ply"
  depends_on "python-setuptools" # for `distutils`

  resource "beniget" do
    url "https://files.pythonhosted.org/packages/14/e7/50cbac38f77eca8efd39516be6651fdb9f3c4c0fab8cf2cf05f612578737/beniget-0.4.1.tar.gz"
    sha256 "75554b3b8ad0553ce2f607627dad3d95c60c441189875b98e097528f8e23ac0c"
  end

  resource "gast" do
    url "https://files.pythonhosted.org/packages/e4/41/f26f62ebef1a80148e20951a6e9ef4d0ebbe2090124bc143da26e12a934c/gast-0.5.4.tar.gz"
    sha256 "9c270fe5f4b130969b54174de7db4e764b09b4f7f67ccfc32480e29f78348d97"
  end

  def pythons
    deps.map(&:to_formula)
        .select { |f| f.name.start_with?("python@") }
        .sort_by(&:version)
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

    clis = %w[pythran pythran-config]

    pythons.each do |python|
      python_exe = python.opt_libexec/"bin/python"
      pyversion = Language::Python.major_minor_version(python_exe)

      resources.each do |r|
        r.stage do
          system python_exe, "-m", "pip", "install", *std_pip_args, "."
        end
      end

      system python_exe, "-m", "pip", "install", *std_pip_args, "."

      clis.each do |cli|
        bin.install bin/cli => "#{cli}-#{pyversion}"
      end

      next if python != pythons.max_by(&:version)

      # The newest one is used as the default
      clis.each do |cli|
        bin.install_symlink "#{cli}-#{pyversion}" => cli
      end
    end
  end

  test do
    pythons.each do |python|
      python_exe = python.opt_libexec/"bin/python"
      pyversion = Language::Python.major_minor_version(python_exe)
      pythran = Formula["pythran"].opt_bin/"pythran-#{pyversion}"

      (testpath/"dprod.py").write <<~EOS
        #pythran export dprod(int list, int list)
        def dprod(arr0, arr1):
          return sum([x*y for x,y in zip(arr0, arr1)])
      EOS
      system pythran, testpath/"dprod.py"
      rm_f testpath/"dprod.py"

      assert_equal "11", shell_output("#{python_exe} -c 'import dprod; print(dprod.dprod([1,2], [3,4]))'").chomp

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

      system python_exe, "-c", <<~EOS
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
end
