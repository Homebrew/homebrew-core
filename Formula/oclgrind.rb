class Oclgrind < Formula
  desc "OpenCL device simulator and debugger"
  homepage "https://github.com/jrprice/Oclgrind"
  url "https://github.com/jrprice/Oclgrind/archive/v21.10.tar.gz"
  sha256 "b40ea81fcf64e9012d63c3128640fde9785ef4f304f9f876f53496595b8e62cc"
  license "BSD-3-Clause"
  revision 1

  livecheck do
    url :homepage
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_monterey: "04c4d2f631fc6d60116b5d7399deb671d5bdde333f6e2fe10aeb50b4db847feb"
    sha256 cellar: :any,                 arm64_big_sur:  "5b1aa1409282fd96fa062506c547820ca830792c6fd001ba6aaa857b3dc873af"
    sha256 cellar: :any,                 monterey:       "2a63ba6a8c9521f8bed0bdf1cc61d4f61917b576c3f0895bbce2d8c18300bc8c"
    sha256 cellar: :any,                 big_sur:        "c1ebca0bf6a54f62b1e6fb1bccdedd144fbf6af607a910a9c73a6cb641abd1c7"
    sha256 cellar: :any,                 catalina:       "84cc33cd385f5e94480c0c8ea5aaaa9a51415d428a0067068c8bbc951abd72b8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f10dc01f531e2961be864dcd3318c24d7bfd148cd788f3edede26987e73bf0d4"
  end

  depends_on "cmake" => :build
  depends_on "llvm@13"
  depends_on "readline"

  on_linux do
    depends_on "opencl-headers" => :test
    depends_on "gcc"
  end

  fails_with gcc: "5" # LLVM is built with GCC

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args, "-DCMAKE_INSTALL_RPATH=#{rpath}"
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    # Install the optional ICD into #{prefix}/etc rather than #{etc} as it contains realpath
    # to the shared library and needs to be kept up-to-date to work with an ICD loader.
    # This relies on `brew link` automatically creating and updating #{etc} symlinks.
    (prefix/"etc/OpenCL/vendors").install "build/oclgrind.icd"
  end

  test do
    (testpath/"rot13.c").write <<~EOS
      #include <stdio.h>
      #include <stdlib.h>
      #include <string.h>
      #include <#{OS.mac? ? "OpenCL" : "CL"}/cl.h>

      const char rot13_cl[] = "                         \\
      __kernel void rot13                               \\
          (   __global    const   char*    in           \\
          ,   __global            char*    out          \\
          )                                             \\
      {                                                 \\
          const uint index = get_global_id(0);          \\
                                                        \\
          char c=in[index];                             \\
          if (c<'A' || c>'z' || (c>'Z' && c<'a')) {     \\
              out[index] = in[index];                   \\
          } else {                                      \\
              if (c>'m' || (c>'M' && c<'a')) {          \\
                out[index] = in[index]-13;              \\
              } else {                                  \\
                out[index] = in[index]+13;              \\
              }                                         \\
          }                                             \\
      }                                                 \\
      ";

      void rot13 (char *buf) {
        int index=0;
        char c=buf[index];
        while (c!=0) {
          if (c<'A' || c>'z' || (c>'Z' && c<'a')) {
            buf[index] = buf[index];
          } else {
            if (c>'m' || (c>'M' && c<'a')) {
              buf[index] = buf[index]-13;
            } else {
              buf[index] = buf[index]+13;
            }
          }
          c=buf[++index];
        }
      }

      int main() {
        char buf[]="Hello, World!";
        size_t srcsize, worksize=strlen(buf);

        cl_int error;
        cl_platform_id platform;
        cl_device_id device;
        cl_uint platforms, devices;

        error=clGetPlatformIDs(1, &platform, &platforms);
        error=clGetDeviceIDs(platform, CL_DEVICE_TYPE_ALL, 1, &device, &devices);
        cl_context_properties properties[]={
                CL_CONTEXT_PLATFORM, (cl_context_properties)platform,
                0};

        cl_context context=clCreateContext(properties, 1, &device, NULL, NULL, &error);
        cl_command_queue cq = clCreateCommandQueue(context, device, 0, &error);

        rot13(buf);

        const char *src=rot13_cl;
        srcsize=strlen(rot13_cl);

        const char *srcptr[]={src};
        cl_program prog=clCreateProgramWithSource(context,
                1, srcptr, &srcsize, &error);
        error=clBuildProgram(prog, 0, NULL, "", NULL, NULL);

        if (error == CL_BUILD_PROGRAM_FAILURE) {
          size_t logsize;
          clGetProgramBuildInfo(prog, device, CL_PROGRAM_BUILD_LOG, 0, NULL, &logsize);

          char *log=(char *)malloc(logsize);
          clGetProgramBuildInfo(prog, device, CL_PROGRAM_BUILD_LOG, logsize, log, NULL);

          fprintf(stderr, "%s\\n", log);
          free(log);

          return 1;
        }

        cl_mem mem1, mem2;
        mem1=clCreateBuffer(context, CL_MEM_READ_ONLY, worksize, NULL, &error);
        mem2=clCreateBuffer(context, CL_MEM_WRITE_ONLY, worksize, NULL, &error);

        cl_kernel k_rot13=clCreateKernel(prog, "rot13", &error);
        clSetKernelArg(k_rot13, 0, sizeof(mem1), &mem1);
        clSetKernelArg(k_rot13, 1, sizeof(mem2), &mem2);

        char buf2[sizeof buf];
        buf2[0]='?';
        buf2[worksize]=0;

        error=clEnqueueWriteBuffer(cq, mem1, CL_FALSE, 0, worksize, buf, 0, NULL, NULL);
        error=clEnqueueNDRangeKernel(cq, k_rot13, 1, NULL, &worksize, &worksize, 0, NULL, NULL);
        error=clEnqueueReadBuffer(cq, mem2, CL_FALSE, 0, worksize, buf2, 0, NULL, NULL);
        error=clFinish(cq);

        puts(buf2);
      }
    EOS

    system ENV.cc, "rot13.c", "-o", "rot13", "-L#{lib}", "-loclgrind-rt"
    output = shell_output("#{bin}/oclgrind ./rot13 2>&1").chomp
    assert_equal "Hello, World!", output
  end
end
