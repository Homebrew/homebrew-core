class Oclgrind < Formula
  desc "OpenCL device simulator and debugger"
  homepage "https://github.com/jrprice/Oclgrind"
  url "https://github.com/jrprice/Oclgrind/archive/v21.10.tar.gz"
  sha256 "b40ea81fcf64e9012d63c3128640fde9785ef4f304f9f876f53496595b8e62cc"
  license "BSD-3-Clause"
  revision 2

  livecheck do
    url :homepage
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "89a927ac8cfbfe82e860a05347a7d7ca61bf3d426e2e3c6ab8c3ff93358230de"
    sha256 cellar: :any,                 arm64_monterey: "952c3159099400839aaadcebec2c20f08bce32dc7de9e507d8435df6a5ba2e9a"
    sha256 cellar: :any,                 arm64_big_sur:  "b56d81e7e93e41f6e339f216392541d1270a3c309d57d83328cf531802bc483c"
    sha256 cellar: :any,                 ventura:        "c5c442f08c52f8a2a3ba70c9def1ce6b15d618c1952aefd3acb4b221be0cf7b9"
    sha256 cellar: :any,                 monterey:       "4c9b7d599bde78dd00085ff802b84b499008e5800fc9c91a11901c9b0fec5c75"
    sha256 cellar: :any,                 big_sur:        "37bf40f81471fedbeb7c295c7c6ecf22f2f2d32c28dd8d8e273922a66a959129"
    sha256 cellar: :any,                 catalina:       "52da235facbe5b6d02b0990c8d987223ba8bd18e003820c4860b4fa5475179b3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "658070a3826a514c4d72109792dfb85d5d79d6d4df5f79fee780f29edf0842b7"
  end

  depends_on "cmake" => :build
  depends_on "llvm@13"
  depends_on "readline"

  on_linux do
    depends_on "opencl-headers" => :test
  end

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
