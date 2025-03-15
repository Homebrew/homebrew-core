class ProjectmEval < Formula
  desc "Milkdrop-compatible music visualizer preset evaluation library"
  homepage "https://github.com/projectM-visualizer/projectm-eval"
  url "https://github.com/projectM-visualizer/projectm-eval.git",
      branch: "master",
      revision: "ee180a2473c12856fd25dc754bafdab7e843cc7a"
  version "HEAD-ee180a"
  license "LGPL-2.1-or-later"

  depends_on "bison" => :build
  depends_on "flex" => :build
  depends_on "cmake" => :build
  depends_on "pkgconf" => [:build, :test]

  def install
    system "cmake", "-S", ".", "-B", "build", "-DENABLE_PROJECTM_EVAL_INSTALL=ON", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

     # Create pkgconfig file
     (lib/"pkgconfig/projectM-Eval.pc").write <<~EOS
     prefix=#{prefix}
     exec_prefix=${prefix}
     libdir=${exec_prefix}/lib
     includedir=${prefix}/include/projectm-eval

     Name: projectM-Eval
     Description: Milkdrop-compatible music visualizer preset evaluation library
     Version: #{version}
     Libs: -L${libdir} -lprojectM_eval
     Cflags: -I${includedir}
   EOS
  end

  test do
    assert_predicate lib/"libprojectM_eval.a", :exist?
    system "pkg-config", "--exists", "projectM-eval"
  end
end
