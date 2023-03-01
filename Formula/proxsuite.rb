class Proxsuite < Formula
  desc "Advanced Proximal Optimization Toolbox"
  homepage "https://github.com/Simple-Robotics/proxsuite"
  url "https://github.com/Simple-Robotics/proxsuite/releases/download/v0.3.4/proxsuite-0.3.4.tar.gz"
  sha256 "98ee4fb7964fb9b6d4cc7875381010c785b9d647481f2f3b2c5b98373a29ddf7"
  license "BSD-2-Clause"
  head "https://github.com/Simple-Robotics/proxsuite.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "ec1274054c000c01381b5c284e34dd761c42fd66c63b3f36c2793480a45e9d43"
    sha256 cellar: :any,                 arm64_monterey: "6862764851487f4bfb2ad7ac0b8b024fec936ae739889d82ba276b9c91eed9bf"
    sha256 cellar: :any,                 arm64_big_sur:  "426a66d29b08437ba193854ff14dd19459a8808c89769104fc9555572cee61ef"
    sha256 cellar: :any,                 ventura:        "399c15e0cb3f1ac9bf528416a196d9a16b92f83fadce4f2b772fee082d97893f"
    sha256 cellar: :any,                 monterey:       "bee07430fbcca057e08c96c7e66687d6424443e96d3e77cf68b3df00c3f0c688"
    sha256 cellar: :any,                 big_sur:        "b0a113406ffa2eb2f100aee927a9616be2c2ddec860c917948dfb4a816f651e1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d4610bdef4269fbf5c31fbdcf4369c414786fc8e092ca4ad33bb0847ecd58677"
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
