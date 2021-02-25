class Openmama < Formula
  desc "Open source high performance messaging API for various Market Data sources"
  homepage "https://openmama.finos.org"
  url "https://github.com/finos/OpenMAMA/archive/OpenMAMA-6.3.1-release.tar.gz"
  sha256 "43e55db00290bc6296358c72e97250561ed4a4bb3961c1474f0876b81ecb6cf9"
  license "LGPL-2.1-only"

  depends_on "cmake" => :build
  depends_on "apr"
  depends_on "apr-util"
  depends_on "libevent"
  depends_on "ossp-uuid"
  depends_on "qpid-proton"

  uses_from_macos "flex" => :build

  def install
    mkdir "build" do
      system "cmake", "..",
        "-DAPR_ROOT=#{Formula["apr"].opt_prefix}",
        "-DPROTON_ROOT=#{Formula["qpid-proton"].opt_prefix}",
        "-DCMAKE_INSTALL_RPATH=#{opt_lib}",
        "-DINSTALL_RUNTIME_DEPENDENCIES=OFF",
        "-DWITH_TESTTOOLS=OFF",
        *std_cmake_args
      system "make", "install"
    end
  end

  test do
    system "#{bin}/mamalistenc", "-?"
    (testpath/"test.c").write <<~EOS
      #include <mama/mama.h>
      #include <stdio.h>
      int main() {
          mamaBridge bridge;
          fclose(stderr);
          mama_status status = mama_loadBridge(&bridge, "qpid");
          if (status != MAMA_STATUS_OK) return 1;
          const char* version = mama_getVersion(bridge);
          if (NULL == version) return 2;
          printf("%s\\n", version);
          return 0;
      }
    EOS
    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lmama", "-o", "test"
    assert_includes shell_output("./test"), version.to_s
  end
end
