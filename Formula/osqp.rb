class Osqp < Formula
  desc "Operator splitting QP solver"
  homepage "https://osqp.org/"
  url "https://github.com/oxfordcontrol/osqp/archive/v0.6.2.tar.gz"
  sha256 "d973c33c3164caa381ed7387375347a46f7522523350a4e51989479b9d3b59c7"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "ec80a9667887ae925ed2951fc41bee5dc39e9c7ee5f37009ed902b3c4d67d63c"
    sha256 cellar: :any,                 arm64_big_sur:  "e632fa361ed8e194da854c8caff4b015482015fda56af0bd6f0ca76bbadecc74"
    sha256 cellar: :any,                 monterey:       "58ed571c455f3e77caca3db8b5862a04b29842ab98f5fa55ad415cf2784e6f45"
    sha256 cellar: :any,                 big_sur:        "875d53798462ef836a86415604f94d903ef6b6974732292aaf6bed3d37f69e5f"
    sha256 cellar: :any,                 catalina:       "2f78c81c56d6f153e55f6e6ce4524eec62cf806b7834ef48337d08aefb2643ec"
    sha256 cellar: :any,                 mojave:         "2f15d564ee6028766215aa931f0ee0c65af87da9fe4697662354a6b9c53e1a30"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b135456e8959fb3417d10dba3924fe6f78510b67eaea4a020a231f4f821c9bd0"
  end

  depends_on "cmake" => [:build, :test]

  resource "qdldl" do
    url "https://github.com/oxfordcontrol/qdldl/archive/v0.1.5.tar.gz"
    sha256 "2868b0e61b7424174e9adef3cb87478329f8ab2075211ef28fe477f29e0e5c99"
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
    rm lib/shared_library("libqdldl")
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
    # from https://github.com/oxfordcontrol/osqp/blob/HEAD/tests/demo/test_demo.h
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
