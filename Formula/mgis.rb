class Mgis < Formula
  desc "Provide tools to handle MFront generic interface behaviours"
  homepage "https://thelfer.github.io/mgis/web/index.html"
  url "https://github.com/thelfer/MFrontGenericInterfaceSupport/archive/refs/tags/MFrontGenericInterfaceSupport-2.0.tar.gz"
  sha256 "cb427d77f2c79423e969815b948a8b44da33a4370d1760e8c1e22a569f3585e2"
  license "GPL-1.0-or-later"
  head "https://github.com/thelfer/MFrontGenericInterfaceSupport.git", using: :git, branch: "master"

  depends_on "cmake" => :build
  depends_on "llvm" => :build
  depends_on "boost-python3"
  depends_on "numpy"
  depends_on "python@3.10"

  def install
    args = [
      "-Denable-portable-build=ON",
      "-Denable-website=OFF",
      "-Denable-enable-doxygen-doc=OFF",
      "-Denable-c-bindings=ON",
      "-Denable-fortran-bindings=ON",
      "-Denable-python-bindings=ON",  # requires boost-python
      "-Denable-fenics-bindings=OFF", # experimental and very limited
      "-Denable-julia-bindings=OFF",  # requires CxxWrap library
      "-Denable-enable-static=OFF",
    ]
    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    system "python3", "-c", "import mgis.behaviour", ">", "log_behaviour.out"
    refute_predicate "log_behaviour.out", :empty?
    system "python3", "-c", "import mgis.model", ">", "log_model.out"
    refute_predicate "log_model.out", :empty?
  end
end
