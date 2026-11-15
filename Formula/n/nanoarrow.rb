class Nanoarrow < Formula
  desc "Helpers for Arrow C Data & Arrow C Stream interfaces"
  homepage "https://arrow.apache.org/nanoarrow"
  url "https://github.com/apache/arrow-nanoarrow/releases/download/apache-arrow-nanoarrow-0.9.0/apache-arrow-nanoarrow-0.9.0.tar.gz"
  sha256 "801200a0e95e869d5c4bdeb5b535dba58551482bb782b7dc8bd599c8b6e8cacf"
  license "Apache-2.0"
  compatibility_version 1

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_golden_gate: "a9cf515ce719208286d7711e11310d2e17e494b53e903637e32d213c9ff59d4d"
    sha256 cellar: :any, arm64_tahoe:       "05e38f5f26b17f039c6b44dbda1f9808ed840b2e79e8f4eae668ad4c57852bf2"
    sha256 cellar: :any, arm64_sequoia:     "2dbc5294a93664ec30176212ce50918e856ffb76e4ba8de888ad21eec297ff08"
    sha256 cellar: :any, arm64_linux:       "f70a15dd725d21f7b631d0599539c9f7061ef452ef67c370c28961068268d7de"
    sha256 cellar: :any, x86_64_linux:      "29f62d89306b9b292d0b2fcb8f0caf3b738e2c569188b4238caefbfe24f1bff5"
  end

  depends_on "cmake" => :build
  depends_on "flatcc"

  # Allow linking against a shared flatccrt
  patch do
    url "https://github.com/apache/arrow-nanoarrow/commit/4c8bedd1db791914068cb19e17a98c5e6ef70582.patch?full_index=1"
    sha256 "e77804be9bd97b638e4aa22f490c2bcb1646d8b6d5fa11b4e1a33ab82aca598f"
    type :unofficial
    resolves "https://github.com/apache/arrow-nanoarrow/pull/949"
  end

  deny_network_access!

  def install
    args = %W[
      -DCMAKE_INSTALL_RPATH=#{rpath}
      -DNANOARROW_FLATCC_ROOT_DIR=#{formula_opt_prefix("flatcc")}
      -DNANOARROW_IPC=ON
    ]
    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <nanoarrow/nanoarrow.h>

      int main() {
        ArrowBufferAllocatorDefault();
        return 0;
      }
    C
    system ENV.cc, "test.c", "-L#{lib}", "-lnanoarrow_shared", "-o", "test"
    system "./test"

    # Test IPC functionality
    (testpath/"test_ipc.c").write <<~C
      #include <nanoarrow/nanoarrow.h>
      #include <nanoarrow/nanoarrow_ipc.h>

      int main() {
        struct ArrowIpcInputStream input;
        input.release = NULL;
        return 0;
      }
    C
    system ENV.cc, "test_ipc.c", "-L#{lib}", "-lnanoarrow_shared", "-lnanoarrow_ipc_shared", "-o", "test_ipc"
    system "./test_ipc"
  end
end
