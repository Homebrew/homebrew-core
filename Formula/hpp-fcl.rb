class HppFcl < Formula
  desc "Extension of the Flexible Collision Library"
  homepage "https://github.com/humanoid-path-planner/hpp-fcl"
  url "https://github.com/humanoid-path-planner/hpp-fcl/releases/download/v1.7.5/hpp-fcl-1.7.5.tar.gz"
  sha256 "eb2755d6ef53786a3b1e62279810af7e96304322561ab371140d7310058849a4"
  license "BSD-2-Clause"
  head "https://github.com/humanoid-path-planner/hpp-fcl.git", branch: "devel"

  depends_on "cmake" => :build
  depends_on "doxygen" => :build
  depends_on "pkg-config" => :build
  depends_on "assimp"
  depends_on "boost"
  depends_on "boost-python3"
  depends_on "cddlib"
  depends_on "eigen"
  depends_on "eigenpy"
  depends_on "octomap"
  depends_on "python@3.9"

  def install
    if build.head?
      system "git", "submodule", "update", "--init"
      system "git", "pull", "--unshallow", "--tags"
    end

    pyver = Language::Python.major_minor_version "python3"
    python = Formula["python@#{pyver}"].opt_bin/"python#{pyver}"
    ENV.prepend_path "Eigen3_DIR", Formula["eigen"].opt_share/"eigen3/cmake"

    mkdir "build" do
      args = *std_cmake_args
      args << "-DPYTHON_EXECUTABLE=#{python}"
      args << "-DBUILD_UNIT_TESTS=OFF"
      args << "-DCMAKE_CXX_STANDARD=11"

      system "cmake", "..", *args
      system "make"
      system "make", "install"
    end
  end

  test do
    system Formula["python@3.9"].opt_bin/"python3", "-c", <<~EOS
      import numpy as np
      import hppfcl
      T = hppfcl.Transform3f()
      R = T.getRotation()
      assert np.isclose(R,np.eye(3)).all()
    EOS
  end
end
