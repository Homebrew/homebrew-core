class Pythran < Formula
  include Language::Python::Virtualenv

  desc "Ahead of Time compiler for numeric kernels"
  homepage "https://pythran.readthedocs.io/"
  url "https://files.pythonhosted.org/packages/82/31/cc6fd7a2b91efc6cdb03e7c42df895b4a65a8f049b074579d45d1def746f/pythran-0.15.0.tar.gz"
  sha256 "f9bc61bcb96df2cd4b578abc5a62dfb3fbb0b0ef02c264513dfb615c5f87871c"
  license "BSD-3-Clause"
  head "https://github.com/serge-sans-paille/pythran.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "18327b6119a4e8d127c5425c0b459b856a775b8bdb553d7b8e5c3a3e2d038f87"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9c86c216e0d0adc371a57feadf7772fad2561c34273a7cc22efba05fe6bb04bd"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9a6330ba2011cf8ef566f308a11a60a23133f8127173acd56148225789916b8a"
    sha256 cellar: :any_skip_relocation, sonoma:         "d431cb54d3078ef33cae0bb00a9400fc7786acefb78e232b38966547190a66f7"
    sha256 cellar: :any_skip_relocation, ventura:        "4e0040f0fcfb919eefad7f0490e06604816a228124654bb12327fc18b6599236"
    sha256 cellar: :any_skip_relocation, monterey:       "33a3f116d7a84a09d7e3ae6af205b057cc3d8012f99ae15cf3b8595bddf2039c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "449118b7ab431e9478525f7cedbc7f075d8075d2f409f3be5d40c89eb89dfaef"
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
