class Proxsuite < Formula
  desc "Advanced Proximal Optimization Toolbox"
  homepage "https://github.com/Simple-Robotics/proxsuite"
  url "https://github.com/Simple-Robotics/proxsuite/releases/download/v0.3.1/proxsuite-0.3.1.tar.gz"
  sha256 "049a9b79f801c45a2e63d41e92891cdae5ffeeac84a25ac5e3be1fcf229048dc"
  license "BSD-2-Clause"
  head "https://github.com/Simple-Robotics/proxsuite.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "8760360d0ed203e24d9a3a1136fc725d2f6045e558f94932743a14e85354fee8"
    sha256 cellar: :any,                 arm64_monterey: "f78b5a5c90361f5ced2a2a0fc74c5c110959d6192da95826654024340c7bfa95"
    sha256 cellar: :any,                 arm64_big_sur:  "aa56177124c96aac6ab153a7fb5c40d6dc23497fe28bafcb7f6249d47381318f"
    sha256 cellar: :any,                 ventura:        "545a7984bf89203ddb099c68c7e54c75af5e5660892739f97740d604436e6895"
    sha256 cellar: :any,                 monterey:       "e5d377f7f7f184301c9677e519067b489111acfa0794dfbd21bb22f68360e0cf"
    sha256 cellar: :any,                 big_sur:        "dd2f709442c578d4e3117f66bdbe8e854a04f18ed7e3d18624d95f75b5d6cbcf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "60cb0621bf68dd52573e8d994d74cd6095e801ca5d4623c87dcf63f8dd7352f0"
  end

  depends_on "cmake" => :build
  depends_on "doxygen" => :build
  depends_on "pkg-config" => :build
  depends_on "eigen"
  depends_on "numpy"
  depends_on "python@3.11"
  depends_on "scipy"
  depends_on "simde"

  def install
    if build.head?
      system "git", "submodule", "update", "--init"
      system "git", "pull", "--unshallow", "--tags"
    end

    ENV.prepend_path "PYTHONPATH", Formula["eigenpy"].opt_prefix/Language::Python.site_packages

    # simde include dir can be removed after https://github.com/Simple-Robotics/proxsuite/issues/65
    system "cmake", "-S", ".", "-B", "build",
                    "-DPYTHON_EXECUTABLE=#{Formula["python@3.11"].opt_libexec/"bin/python"}",
                    "-DBUILD_UNIT_TESTS=OFF",
                    "-DBUILD_PYTHON_INTERFACE=ON",
                    "-DINSTALL_DOCUMENTATION=ON",
                    "-DSimde_INCLUDE_DIR=#{Formula["simde"].opt_prefix/"include"}",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    python_exe = Formula["python@3.11"].opt_libexec/"bin/python"
    system python_exe, "-c", <<~EOS
      import proxsuite
      qp = proxsuite.proxqp.dense.QP(10,0,0)
      assert qp.model.H.shape[0] == 10 and qp.model.H.shape[1] == 10
    EOS
  end
end
