class Proxsuite < Formula
  desc "Advanced Proximal Optimization Toolbox"
  homepage "https://github.com/Simple-Robotics/proxsuite"
  url "https://github.com/Simple-Robotics/proxsuite/releases/download/v0.5.0/proxsuite-0.5.0.tar.gz"
  sha256 "c2e928aa35c42fdc5297a81b9dcc6a7f927c8a0b01a18d1984780d67debdaa76"
  license "BSD-2-Clause"
  head "https://github.com/Simple-Robotics/proxsuite.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "605b6495d595e31b1ab6d1613b80509d8ed651e85a1fc0db144784b5141aeb37"
    sha256 cellar: :any,                 arm64_ventura:  "4acf49678b9eab165289b45f289c66643f8e4cef6fedf6d2c38378f16198c17d"
    sha256 cellar: :any,                 arm64_monterey: "0726137f73e8ea65194273419f78e84eb58303cd77c451ae6bfbaa6edec6e3fc"
    sha256 cellar: :any,                 sonoma:         "fded3ec2005a279e86424e6740292caadad73bce7239cbde90b0ab01b0c19481"
    sha256 cellar: :any,                 ventura:        "fa5ec4312a9775330d3a42bd94c8ade9fa462bdc99d3ecbfbd54ec9ac829bd9a"
    sha256 cellar: :any,                 monterey:       "ed57dfda75eb6de9d01ba8c9fc296fe6815ad5806fa3b381149aa9325aef5577"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "87ec9b9f689e2a30cf637e6c7a24ab33200ded3fac92e8e7d709093d8fa3f190"
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
    system "git", "submodule", "update", "--init", "--recursive" if build.head?

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
