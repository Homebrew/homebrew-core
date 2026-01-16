class Osqp < Formula
  desc "Operator splitting QP solver"
  homepage "https://osqp.org/"
  url "https://github.com/osqp/osqp/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "dd6a1c2e7e921485697d5e7cdeeb043c712526c395b3700601f51d472a7d8e48"
  license "Apache-2.0"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "c954c2ec86a360b05b33c2adca519d53f4b4a668ec21dd1843c0a03811239b5d"
    sha256 cellar: :any,                 arm64_sequoia: "ccb60f0cfb872511bca80235ac7a946fa63b37a5a3dd12824225233b53da0a0c"
    sha256 cellar: :any,                 arm64_sonoma:  "5fed88abe2497775db7e0b621beb464077d9a9d17b5d78d0e02572be8baf55dc"
    sha256 cellar: :any,                 arm64_ventura: "108db6550c4c298e1da86ebe8577727a0bd507f1889a3e2bfdf67f7aec8d24fc"
    sha256 cellar: :any,                 sonoma:        "4870c87ac958b12511c5eee404fe346a0e2d0372b379855f934533ab8e2b039b"
    sha256 cellar: :any,                 ventura:       "2de9db6218208bcce319b7ab4a6f8ce9b74af95a8571168afce565f62bbc01b6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6544280d65567811ac1fa3bd1f659545a0a1e02f50ca43f946761d325818e85d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f28787efc1e418c84e3123f0364865950be5f51250246d916419ed8d53b09cd4"
  end

  depends_on "cmake" => [:build, :test]

  resource "qdldl" do
    url "https://github.com/osqp/qdldl/archive/refs/tags/v0.1.8.tar.gz"
    sha256 "ecf113fd6ad8714f16289eb4d5f4d8b27842b6775b978c39def5913f983f6daa"

    livecheck do
      url "https://raw.githubusercontent.com/osqp/osqp/refs/tags/v#{LATEST_VERSION}/algebra/_common/lin_sys/qdldl/qdldl.cmake"
      regex(/GIT_TAG\s+v?(\d+(?:\.\d+)+)/i)
    end
  end

  def install
    (buildpath/"qdldl").install resource("qdldl")

    system "cmake", "-S", ".", "-B", "build", "-DFETCHCONTENT_SOURCE_DIR_QDLDL=#{buildpath}/qdldl", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    # Remove unnecessary qdldl install.
    rm_r(Dir[include/"qdldl", lib/"cmake/qdldl", lib/"libqdldl.a", lib/shared_library("libqdldl")])
  end

  test do
    (testpath/"CMakeLists.txt").write <<~CMAKE
      cmake_minimum_required(VERSION 4.0 FATAL_ERROR)
      project(osqp_demo LANGUAGES C)
      find_package(osqp CONFIG REQUIRED)

      add_executable(osqp_demo osqp_demo.c)
      target_link_libraries(osqp_demo PRIVATE osqp::osqp -lm)

      add_executable(osqp_demo_static osqp_demo.c)
      target_link_libraries(osqp_demo_static PRIVATE osqp::osqpstatic -lm)
    CMAKE

    # https://github.com/osqp/osqp/blob/master/examples/osqp_simple_demo.c
    (testpath/"osqp_demo.c").write <<~C
      #include <assert.h>
      #include <stdlib.h>
      #include <osqp.h>

      int main() {
        OSQPFloat P_x[3] = { 4.0, 1.0, 2.0, };
        OSQPInt   P_nnz  = 3;
        OSQPInt   P_i[3] = { 0, 0, 1, };
        OSQPInt   P_p[3] = { 0, 1, 3, };
        OSQPFloat q[2]   = { 1.0, 1.0, };
        OSQPFloat A_x[4] = { 1.0, 1.0, 1.0, 1.0, };
        OSQPInt   A_nnz  = 4;
        OSQPInt   A_i[4] = { 0, 1, 0, 2, };
        OSQPInt   A_p[3] = { 0, 2, 4, };
        OSQPFloat l[3]   = { 1.0, 0.0, 0.0, };
        OSQPFloat u[3]   = { 1.0, 0.7, 0.7, };
        OSQPInt   n = 2;
        OSQPInt   m = 3;
        OSQPInt exitflag;
        OSQPSolver*   solver   = NULL;
        OSQPSettings* settings = OSQPSettings_new();
        OSQPCscMatrix* P = OSQPCscMatrix_new(n, n, P_nnz, P_x, P_i, P_p);
        OSQPCscMatrix* A = OSQPCscMatrix_new(m, n, A_nnz, A_x, A_i, A_p);
        if (settings) {
          settings->polishing = 1;
        }
        OSQPInt cap = osqp_capabilities();
        exitflag = osqp_setup(&solver, P, q, A, l, u, m, n, settings);
        assert(exitflag == 0);
        exitflag = osqp_solve(solver);
        osqp_cleanup(solver);
        OSQPCscMatrix_free(A);
        OSQPCscMatrix_free(P);
        OSQPSettings_free(settings);
        return (int)exitflag;
      }
    C

    system "cmake", "-S", ".", "-B", "build"
    system "cmake", "--build", "build"
    system "./build/osqp_demo"
    system "./build/osqp_demo_static"
  end
end
