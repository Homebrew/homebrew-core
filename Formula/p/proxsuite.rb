class Proxsuite < Formula
  desc "Advanced Proximal Optimization Toolbox"
  homepage "https://github.com/Simple-Robotics/proxsuite"
  url "https://github.com/Simple-Robotics/proxsuite/releases/download/v0.7.3/proxsuite-0.7.3.tar.gz"
  sha256 "1178721869898401e0a9d7c46803486c87d6ede3356770507dfb1022500a442b"
  license "BSD-2-Clause"
  head "https://github.com/Simple-Robotics/proxsuite.git", branch: "devel"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "0bf056d143141e3660a576f96b2e4522558443aacfcd2e1ec9d40621f421578e"
    sha256 cellar: :any,                 arm64_sequoia: "eead59678eb4a71600feb14764e7748e63166c1790e9dfb435b722a2d56e7229"
    sha256 cellar: :any,                 arm64_sonoma:  "7abbc7e4b505cb780732626cb8864101201c461a9919b063e5f8918b4d318d0d"
    sha256 cellar: :any,                 sonoma:        "249aefe18bee8ce9f9123f35ed09ff00ba654023537826c4c6cb5101d4cce723"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5bf63cea4f9f3f1acfe15b6627759bf6176dc3c21903c355ed2ece2b2243276e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9c7a07960a47c7e1aa6f4f1ab72f82a7dde10197b3dbe5f179c54f3742231905"
  end

  depends_on "cmake" => :build
  depends_on "doxygen" => :build
  depends_on "pkgconf" => :build
  depends_on "eigen"
  depends_on "numpy"
  depends_on "python@3.14"
  depends_on "scipy" => :no_linkage
  depends_on "simde"

  def python3
    "python3.14"
  end

  def install
    system "git", "submodule", "update", "--init", "--recursive" if build.head?

    # Workaround to fix error: a template argument list is expected after
    # a name prefixed by the template keyword [-Wmissing-template-arg-list-after-template-kw]
    if DevelopmentTools.clang_build_version >= 1700
      ENV.append_to_cflags "-Wno-missing-template-arg-list-after-template-kw"
    end

    args = %W[
      -DPYTHON_EXECUTABLE=#{which(python3)}
      -DBUILD_UNIT_TESTS=OFF
      -DBUILD_PYTHON_INTERFACE=ON
      -DINSTALL_DOCUMENTATION=ON
    ]
    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    system python3, "-c", <<~PYTHON
      import proxsuite
      qp = proxsuite.proxqp.dense.QP(10,0,0)
      assert qp.model.H.shape[0] == 10 and qp.model.H.shape[1] == 10
    PYTHON
  end
end
