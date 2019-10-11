class Osqp < Formula
  desc "Operator splitting QP solver"
  homepage "https://osqp.org/"
  url "https://github.com/oxfordcontrol/osqp/archive/v0.6.0.tar.gz"
  sha256 "6e00d11d1f88c1e32a4419324b7539b89e8f9cbb1c50afe69f375347c989ba2b"

  bottle do
    cellar :any
    sha256 "50feea323216bf8cc5d8dda92264a9354d547b5076d4c3b37b75792d0ac14c3f" => :catalina
    sha256 "99a2f2810fc34c0241c0bc4a7bc31704a5b1ccc8201d112735e75cda14bb4bca" => :mojave
    sha256 "2f50e046d34b7556891c7351aeab94347d1404b4ac1dcb041c413c4fb42bf16d" => :high_sierra
  end

  depends_on "cmake" => [:build, :test]

  resource "qdldl" do
    url "https://github.com/oxfordcontrol/qdldl/archive/v0.1.3.tar.gz"
    sha256 "a2c3a7d0c6a48b2fab7400fa8ca72a34fb1e3a19964b281c73564178f97afe54"
  end

  def install
    # Install qdldl git submodule not included in release source archive.
    (buildpath/"lin_sys/direct/qdldl/qdldl_sources").install resource("qdldl")

    args = *std_cmake_args + %w[
      -DENABLE_MKL_PARDISO=OFF
    ]

    mkdir "build" do
      system "cmake", *args, ".."
      system "make"
      system "make", "install"
    end

    # Remove unnecessary qdldl install.
    rm_rf include/"qdldl"
    rm_rf lib/"cmake/qdldl"
    rm lib/"libqdldl.a"
    rm lib/"libqdldl.dylib"
  end

  test do
    (testpath/"CMakeLists.txt").write <<~EOS
      cmake_minimum_required(VERSION 3.2 FATAL_ERROR)
      project(osqp_demo LANGUAGES C)
      find_package(osqp CONFIG REQUIRED)
      add_executable(osqp_demo osqp_demo.c)
      target_link_libraries(osqp_demo PRIVATE osqp::osqp)
      add_executable(osqp_demo_static osqp_demo.c)
      target_link_libraries(osqp_demo_static PRIVATE osqp::osqpstatic)
    EOS
    # from https://github.com/oxfordcontrol/osqp/blob/master/tests/demo/test_demo.h
    (testpath/"osqp_demo.c").write <<~EOS
      #include <assert.h>
      #include <osqp.h>
      int main() {
        c_float P_x[3] = { 4.0, 1.0, 2.0, };
        c_int   P_nnz  = 3;
        c_int   P_i[3] = { 0, 0, 1, };
        c_int   P_p[3] = { 0, 1, 3, };
        c_float q[2]   = { 1.0, 1.0, };
        c_float A_x[4] = { 1.0, 1.0, 1.0, 1.0, };
        c_int   A_nnz  = 4;
        c_int   A_i[4] = { 0, 1, 0, 2, };
        c_int   A_p[3] = { 0, 2, 4, };
        c_float l[3]   = { 1.0, 0.0, 0.0, };
        c_float u[3]   = { 1.0, 0.7, 0.7, };
        c_int n = 2;
        c_int m = 3;
        c_int exitflag;
        OSQPSettings *settings = (OSQPSettings *)c_malloc(sizeof(OSQPSettings));
        OSQPWorkspace *work;
        OSQPData *data;
        data = (OSQPData *)c_malloc(sizeof(OSQPData));
        data->n = n;
        data->m = m;
        data->P = csc_matrix(data->n, data->n, P_nnz, P_x, P_i, P_p);
        data->q = q;
        data->A = csc_matrix(data->m, data->n, A_nnz, A_x, A_i, A_p);
        data->l = l;
        data->u = u;
        osqp_set_default_settings(settings);
        exitflag = osqp_setup(&work, data, settings);
        assert(exitflag == 0);
        osqp_solve(work);
        assert(work->info->status_val == OSQP_SOLVED);
        osqp_cleanup(work);
        c_free(data->A);
        c_free(data->P);
        c_free(data);
        c_free(settings);
        return 0;
      }
    EOS
    system "cmake", "."
    system "make"
    system "./osqp_demo"
    system "./osqp_demo_static"
  end
end
