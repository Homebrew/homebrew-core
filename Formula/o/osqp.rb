class Osqp < Formula
  desc "Operator splitting QP solver"
  homepage "https://osqp.org/"
  url "https://github.com/osqp/osqp/archive/refs/tags/v0.6.3.tar.gz"
  sha256 "a6b4148019001f87489c27232e2bdbac37c94f38fa37c1b4ee11eaa5654756d2"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "647ab37438a0017321a9e6f1182f805cef876a66a2f943d5f23dc59082fd9f0f"
    sha256 cellar: :any,                 arm64_sonoma:   "75737089a5452b23716c6e18c7ec61944a75334727292470db873e951be0ff64"
    sha256 cellar: :any,                 arm64_ventura:  "ca78e8724eade029e62543fd5c71024400dcf7af5e34fcd9b520aa6030ed6a50"
    sha256 cellar: :any,                 arm64_monterey: "037777df22a74ad68ede796d9004ac30939144e63507112f35011d552f6091fd"
    sha256 cellar: :any,                 arm64_big_sur:  "dd0f9790866331141c39a30a19732e5571399d0f7668bc725f5353dcb89c8221"
    sha256 cellar: :any,                 sonoma:         "ddebb766c58dbdedc3dc1689e78f399a324463848238ac82df37139e273f3619"
    sha256 cellar: :any,                 ventura:        "0a8cb981e6a52e00c2db369efd692e41b9bf11aa8644c3337d77bfba91d98761"
    sha256 cellar: :any,                 monterey:       "19a616f01dd68f4f13f128301f3a3d38362482f97be1d10256fdd52f69e10e9f"
    sha256 cellar: :any,                 big_sur:        "7bb862c89dda12256460a5ae9710053a99c413275093aaa2d18d71b676bc9ca7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1fd25cee27a7fb3d5f6ee8e9675f1b069bb4a22e5782f2753f5cd070cc6ba5a0"
  end

  depends_on "cmake" => [:build, :test]

  resource "qdldl" do
    url "https://github.com/osqp/qdldl/archive/refs/tags/v0.1.7.tar.gz"
    sha256 "631ae65f367859fa1efade1656e4ba22b7da789c06e010cceb8b29656bf65757"
  end

  def install
    # Install qdldl git submodule not included in release source archive.
    (buildpath/"lin_sys/direct/qdldl/qdldl_sources").install resource("qdldl")

    system "cmake", "-S", ".", "-B", "build", "-DENABLE_MKL_PARDISO=OFF", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    # Remove unnecessary qdldl install.
    rm_r(Dir[include/"qdldl", lib/"cmake/qdldl", lib/"libqdldl.a", lib/shared_library("libqdldl")])
  end

  test do
    (testpath/"CMakeLists.txt").write <<~EOS
      cmake_minimum_required(VERSION 3.2 FATAL_ERROR)
      project(osqp_demo LANGUAGES C)
      find_package(osqp CONFIG REQUIRED)

      add_executable(osqp_demo osqp_demo.c)
      target_link_libraries(osqp_demo PRIVATE osqp::osqp -lm)

      add_executable(osqp_demo_static osqp_demo.c)
      target_link_libraries(osqp_demo_static PRIVATE osqp::osqpstatic -lm)
    EOS

    # from https://github.com/osqp/osqp/blob/HEAD/tests/demo/test_demo.h
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

    system "cmake", "-S", ".", "-B", "build"
    system "cmake", "--build", "build"
    system "./build/osqp_demo"
    system "./build/osqp_demo_static"
  end
end
