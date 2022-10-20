class Openmama < Formula
  desc "Open source high performance messaging API for various Market Data sources"
  homepage "https://openmama.finos.org"
  url "https://github.com/finos/OpenMAMA/archive/OpenMAMA-6.3.1-release.tar.gz"
  sha256 "43e55db00290bc6296358c72e97250561ed4a4bb3961c1474f0876b81ecb6cf9"
  license "LGPL-2.1-only"

  bottle do
    rebuild 2
    sha256 cellar: :any,                 arm64_monterey: "81aa664271767ec190b914b079f6aaddb4712ea5071ae983f41904ccabacbf75"
    sha256 cellar: :any,                 arm64_big_sur:  "a123162e2ba61eb5c30e56460e0946071d905555dc83183b6f20f8ce6bc65193"
    sha256 cellar: :any,                 monterey:       "178483d87eda050e29c6b646436c0ece4a14dcd5c1d98aec8103a49b97e2857c"
    sha256 cellar: :any,                 big_sur:        "45153901e833685b76160a45e283b21c52e2382f4a1a65092acd97035f75e2ca"
    sha256 cellar: :any,                 catalina:       "363d1c76bec6373017daa21a142f07793f818a2d871960641699b54ef54de980"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "643e5f3db30c0f6ae816f6131f0325e58d2bb82665756449347a0a5751bd88be"
  end

  depends_on "cmake" => :build
  depends_on "apr"
  depends_on "apr-util"
  depends_on "libevent"
  depends_on "qpid-proton"

  uses_from_macos "flex" => :build

  # UUID is provided by util-linux on Linux.
  on_linux do
    depends_on "util-linux"
  end

  def install
    uuid_args = if OS.mac?
      ["-DUUID_INCLUDE_DIRS=#{MacOS.sdk_path_if_needed}/usr/include", "-DUUID_LIBRARIES=c"]
    else
      []
    end

    system "cmake", "-S", ".", "-B", "build",
                    "-DAPR_ROOT=#{Formula["apr"].opt_prefix}",
                    "-DPROTON_ROOT=#{Formula["qpid-proton"].opt_prefix}",
                    "-DCMAKE_INSTALL_RPATH=#{rpath}",
                    "-DINSTALL_RUNTIME_DEPENDENCIES=OFF",
                    "-DWITH_TESTTOOLS=OFF",
                    *uuid_args,
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
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
