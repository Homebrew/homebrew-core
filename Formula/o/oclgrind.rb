class Oclgrind < Formula
  desc "OpenCL device simulator and debugger"
  homepage "https://github.com/jrprice/Oclgrind"
  url "https://github.com/jrprice/Oclgrind/archive/refs/tags/v21.10.tar.gz"
  sha256 "b40ea81fcf64e9012d63c3128640fde9785ef4f304f9f876f53496595b8e62cc"
  license "BSD-3-Clause"
  revision 2

  livecheck do
    url :homepage
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sonoma:   "0dcf5df23a8e0972f081f74a530e1181e17d1fb7ad6d4af5d5a0d40faf25626b"
    sha256 cellar: :any,                 arm64_ventura:  "ed53c5dcfe4878ac26531acdffe5ab48647c48b06f43332993f523986f99c797"
    sha256 cellar: :any,                 arm64_monterey: "39f07818c2dffcce37d58d8aaeba1c824c68c33db786e89d6b692b262b76647a"
    sha256 cellar: :any,                 sonoma:         "8c0333807ba86699af7cbe5daaf1fe1545f1ef0ebd4c93e081ba5b0722a97fba"
    sha256 cellar: :any,                 ventura:        "ddaa39e73997893783482ef2744877704d393e069ddb999aa34ebedd9435d8b9"
    sha256 cellar: :any,                 monterey:       "a04a89b7bde89c7bfa2d83ab13521f8ed5ea8b6b3ce7470ecf3c995408527986"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "867889a512d1c460d03496a763adf0d8c0d18b3ceea4d6ade2907d9513241b9a"
  end

  depends_on "cmake" => :build
  depends_on "llvm@14" # Issue for newer LLVM: https://github.com/jrprice/Oclgrind/issues/209
  depends_on "readline"

  on_linux do
    depends_on "opencl-headers" => :test
  end

  # Backport support for `llvm@14`. Remove in the next release.
  patch do
    url "https://github.com/jrprice/Oclgrind/commit/6c76e7bec0aa7fa451515a5cfcb35ab2384ba6e0.patch?full_index=1"
    sha256 "8c1b8ec75d8d8c8d02246124b40452ec9ef1243d3e3c497fe4ffa8571cd98ade"
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
